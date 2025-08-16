#!/bin/bash

# K8s-RsshD Version Management Script
# Usage: ./scripts/version.sh [major|minor|patch|show]

set -e

VERSION_FILE="VERSION"
CURRENT_VERSION=$(cat $VERSION_FILE 2>/dev/null || echo "0.0.0")

# Parse current version
IFS='.' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR=${VERSION_PARTS[0]:-0}
MINOR=${VERSION_PARTS[1]:-0}
PATCH=${VERSION_PARTS[2]:-0}

show_version() {
    echo "Current version: $CURRENT_VERSION"
    echo "Major: $MAJOR"
    echo "Minor: $MINOR" 
    echo "Patch: $PATCH"
}

bump_version() {
    case $1 in
        major)
            MAJOR=$((MAJOR + 1))
            MINOR=0
            PATCH=0
            ;;
        minor)
            MINOR=$((MINOR + 1))
            PATCH=0
            ;;
        patch)
            PATCH=$((PATCH + 1))
            ;;
        *)
            echo "Invalid version type. Use: major, minor, or patch"
            exit 1
            ;;
    esac
    
    NEW_VERSION="$MAJOR.$MINOR.$PATCH"
    echo "$NEW_VERSION" > $VERSION_FILE
    echo "Version bumped to: $NEW_VERSION"
    
    # Update deployment image tag
    if [ -f "k8s/deployment.yaml" ]; then
        sed -i "s|fedorinoalex/k8s-rsshd:.*|fedorinoalex/k8s-rsshd:$NEW_VERSION|g" k8s/deployment.yaml
        echo "Updated deployment.yaml with new version"
    fi
}

case ${1:-show} in
    show)
        show_version
        ;;
    major|minor|patch)
        bump_version $1
        ;;
    *)
        echo "Usage: $0 [major|minor|patch|show]"
        echo ""
        echo "Commands:"
        echo "  show   - Display current version (default)"
        echo "  major  - Bump major version (X.0.0)"
        echo "  minor  - Bump minor version (x.X.0)" 
        echo "  patch  - Bump patch version (x.x.X)"
        exit 1
        ;;
esac
