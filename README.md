# K8s-RsshD

**Kubernetes-Ready SSH Reverse Tunnel Container**

*Based on original work by Emmanuel Frecon <efrecon@gmail.com>*

A minimal, secure SSH reverse tunnel container designed for Kubernetes deployments. Perfect for maintaining persistent connections to remote servers behind NAT, firewalls, or mobile connections (like Raspberry Pis "in the wild").

## Key Features

- 🔐 **SSH Key-based authentication only** (no passwords)
- ☸️ **Kubernetes-native** with ConfigMap integration
- 🐳 **Minimal Alpine-based** container
- 🔧 **Simple configuration** via Kubernetes manifests
- 🚀 **Zero persistent storage** requirements
- 🔄 **Automatic SSH host key generation**

## Architecture

This container runs an SSH daemon that:
1. **Accepts incoming SSH connections** from remote servers
2. **Creates reverse tunnels** to access those servers
3. **Manages authorized keys** via Kubernetes ConfigMap
4. **Provides secure, passwordless access** to remote infrastructure

## Configuration

### Adding SSH Keys

Edit the ConfigMap to authorize new clients:

```bash
kubectl edit configmap rsshd-authorized-keys
```

Add your public keys:
```yaml
data:
  authorized_keys: |
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... user@hostname
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... another-user@host
```

### Service Configuration

The service exposes:
- **Port 22**: SSH daemon (for incoming connections)
- **Port 80**: Tunnel port (configurable)

Modify `k8s/service.yaml` to add more tunnel ports or change service type.

## Docker Usage (Alternative)

You can also run with Docker directly:

```bash
# Use pre-built image from Docker Hub
docker run -d -p 2222:22 -p 8080:80 \
  -v /path/to/authorized_keys:/tmp/ssh-keys/authorized_keys:ro \
  fedorinoalex/k8s-rsshd:latest

# Or build locally
docker build -t k8s-rsshd:local .
docker run -d -p 2222:22 -p 8080:80 \
  -v /path/to/authorized_keys:/tmp/ssh-keys/authorized_keys:ro \
  k8s-rsshd:local
```

## Remote Server Setup

### 1. Add your public key to ConfigMap
```bash
cat ~/.ssh/id_rsa.pub
```

### 2. Port forward to 22 port
```bash
kubectl port-forward service/k8s-rsshd 2222:22
```

### 3. Create reverse tunnel
```bash
ssh -N -R 80:localhost:5000 -p 2222 root@localhost
```

### 4. Run dev server on 5000 port
```bash
python3 -m http.server 5000 # example http server
```

### 5. Make test call to k8s-rsshd port 80

## Security Features

- **No password authentication** - Keys only
- **Configurable access control** - Via ConfigMap
- **Minimal attack surface** - Alpine-based container
- **Standard SSH security** - Proper file permissions
- **Container isolation** - Optional LOCAL mode for enhanced security

## Troubleshooting

### Check deployment status
```bash
kubectl get pods -l app=rsshd
kubectl logs deployment/rsshd
```

### Verify SSH configuration
```bash
kubectl exec deployment/rsshd -- cat /root/.ssh/authorized_keys
kubectl exec deployment/rsshd -- ssh -T root@localhost
```

### Test connection
```bash
ssh -vv -p 2222 root@<RSSHD-HOST>
```

## Differences from Original

This fork focuses on Kubernetes deployment with these changes:

- ✅ **Simplified architecture** - No persistent volume requirements
- ✅ **Key-based auth only** - Enhanced security
- ✅ **ConfigMap integration** - Kubernetes-native key management
- ✅ **Reduced complexity** - Removed custom key storage logic
- ✅ **Production ready** - Proper health checks and resource limits

## License

This project is based on the original RsshD by Emmanuel Frecon, licensed under the BSD 2-Clause License. See [LICENSE](LICENSE) and [ATTRIBUTION.md](ATTRIBUTION.md) for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with Kubernetes
5. Submit a pull request

### Version Management

This project uses [Conventional Commits](https://www.conventionalcommits.org/) for **automatic version bumping**:

```bash
# Commits automatically trigger version bumps:
git commit -m "feat: add new feature"     # Minor bump (1.0.0 → 1.1.0)
git commit -m "fix: resolve bug"          # Patch bump (1.1.0 → 1.1.1)  
git commit -m "feat!: breaking change"    # Major bump (1.1.1 → 2.0.0)
```

**Manual version management** (if needed):
```bash
# Check current version
./scripts/version.sh show

# Manual bumps (use conventional commits instead)
./scripts/version.sh patch    # 1.0.0 → 1.0.1
./scripts/version.sh minor    # 1.0.1 → 1.1.0
./scripts/version.sh major    # 1.1.0 → 2.0.0
```

See [CONVENTIONAL_COMMITS.md](CONVENTIONAL_COMMITS.md) for complete guide.

### Creating Releases

**Automatic releases** (recommended):
- Just use conventional commit messages
- Versions bump automatically on push to master
- GitHub releases created automatically

**Manual releases** (if needed):
1. Go to **Actions** → **Manual Release** in GitHub
2. Click **Run workflow**
3. Leave version empty for auto-calculation or enter specific version
4. Choose release type (release/prerelease)

The automation:
- ✅ **Analyzes commit messages** for version bump type
- ✅ **Updates VERSION file** and creates git tags
- ✅ **Builds multi-platform Docker images** (amd64, arm64)
- ✅ **Creates GitHub releases** with automated changelog
- ✅ **Pushes to Docker Hub** with semantic version tags

---

*Perfect for connecting to Raspberry Pis, IoT devices, and other remote systems behind firewalls!* 🚀



