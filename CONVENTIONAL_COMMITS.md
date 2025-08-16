# Conventional Commits Guide

This project uses [Conventional Commits](https://www.conventionalcommits.org/) for automatic version bumping.

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types and Version Bumps

| Type | Version Bump | Description | Example |
|------|--------------|-------------|---------|
| `feat:` | **Minor** (0.1.0) | New feature | `feat: add SSH key rotation` |
| `fix:` | **Patch** (0.0.1) | Bug fix | `fix: resolve connection timeout` |
| `feat!:` | **Major** (1.0.0) | Breaking change | `feat!: change SSH port default` |
| `fix!:` | **Major** (1.0.0) | Breaking bug fix | `fix!: remove deprecated API` |
| `docs:` | **Patch** (0.0.1) | Documentation | `docs: update README` |
| `style:` | **Patch** (0.0.1) | Code style | `style: format code` |
| `refactor:` | **Patch** (0.0.1) | Refactoring | `refactor: simplify SSH setup` |
| `perf:` | **Patch** (0.0.1) | Performance | `perf: optimize container startup` |
| `test:` | **Patch** (0.0.1) | Tests | `test: add integration tests` |
| `chore:` | **Patch** (0.0.1) | Maintenance | `chore: update dependencies` |
| `ci:` | **Patch** (0.0.1) | CI/CD | `ci: add Docker build` |
| `build:` | **Patch** (0.0.1) | Build system | `build: update Dockerfile` |

## Breaking Changes

Use `!` after the type or add `BREAKING CHANGE:` in the footer:

```bash
feat!: change default SSH port to 2222

BREAKING CHANGE: Default SSH port changed from 22 to 2222.
Update your configurations accordingly.
```

## Examples

### New Feature (Minor Bump)
```bash
git commit -m "feat: add support for ED25519 keys"
```
**Result**: 1.0.0 → 1.1.0

### Bug Fix (Patch Bump)
```bash
git commit -m "fix: resolve SSH key permission issue"
```
**Result**: 1.1.0 → 1.1.1

### Breaking Change (Major Bump)
```bash
git commit -m "feat!: require Kubernetes 1.25+"
```
**Result**: 1.1.1 → 2.0.0

### Documentation (Patch Bump)
```bash
git commit -m "docs: add troubleshooting section"
```
**Result**: 2.0.0 → 2.0.1

## Automatic Version Bumping

The project automatically bumps versions when:

1. **Push to master/main** - Analyzes all commits since last tag
2. **Merged PR** - Analyzes commits in the PR

The automation:
- ✅ Updates `VERSION` file
- ✅ Creates git tag (e.g., `v1.2.3`)
- ✅ Triggers Docker build
- ✅ Creates GitHub release
- ✅ Generates changelog

## Manual Override

You can still create manual releases via:
- **GitHub Actions** → **Manual Release**
- Leave version empty for auto-calculation
- Or specify exact version

## Tips

- Use clear, descriptive commit messages
- Group related changes in single commits
- Use scopes for better organization: `feat(k8s): add ingress support`
- Test locally before pushing to avoid unwanted version bumps
