# K8s-RsshD Kubernetes Deployment

This directory contains Kubernetes manifests to deploy K8s-RsshD as a single pod with SSH key-based authentication only.

## Attribution

Based on original RsshD by Emmanuel Frecon <efrecon@gmail.com>
- Original repository: https://github.com/efrecon/rsshd
- This fork: https://github.com/fedorino-alex/k8s-rsshd
- Copyright (c) 2016, Emmanuel Frecon
- Copyright (c) 2025, Alex Fedorino
- Licensed under BSD 2-Clause License (see LICENSE file)

## Files

- `configmap.yaml` - ConfigMap containing authorized SSH public keys
- `deployment.yaml` - Main deployment with key-based authentication
- `service.yaml` - Service to expose RsshD
- `README.md` - This documentation

## Quick Start

1. **Edit the ConfigMap** to add your public keys:
   ```bash
   kubectl edit configmap rsshd-authorized-keys
   ```

2. **Deploy everything**:
   ```bash
   kubectl apply -f k8s/
   ```

3. **Get the external IP**:
   ```bash
   kubectl get service rsshd-service
   ```

4. **Connect with your SSH key**:
   ```bash
   ssh -p 2222 root@<EXTERNAL-IP>
   ```

## Configuration

### Adding Public Keys

Edit the ConfigMap to add your public keys:

```bash
kubectl edit configmap rsshd-authorized-keys
```

Or patch it directly:

```bash
kubectl patch configmap rsshd-authorized-keys --patch '
data:
  authorized_keys: |
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ... user@hostname
    ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... another-user@host
'
```

### Authentication Method

This deployment uses **SSH key-based authentication only**. Password authentication is disabled for security.

### Container Configuration

The deployment is configured with:
- **Key-based authentication only** (hardcoded in the container)
- **External tunnel access enabled** by default
- **ConfigMap-mounted authorized keys**

To modify the container behavior, you would need to add environment variables to the deployment. Available options:

- `LOCAL=1` - Restrict tunnel access to container only
- `DISABLE_PASSWORD_AUTH=1` - Force key-based authentication (already default)
- `PASSWORD` - Set root password (not recommended for security)

## Service Types

The service is configured as `LoadBalancer` by default. Change in `service.yaml`:

- `LoadBalancer` - For cloud providers (gets external IP)
- `NodePort` - Exposes on all nodes (access via node IP:nodePort)
- `ClusterIP` - Internal access only

## SSH Tunneling

### Creating Reverse Tunnels

From a remote server, create a reverse tunnel:

```bash
ssh -fN -R 10000:localhost:22 -p 2222 root@<EXTERNAL-IP>
```

### Connecting Through Tunnels

Once a tunnel is established, connect to the remote server:

```bash
ssh -p 10000 user@<EXTERNAL-IP>
```

### Persistent Tunnels with autossh

For permanent connections from remote servers:

```bash
autossh -M 10099 -fN -o "PubkeyAuthentication=yes" \
  -o "StrictHostKeyChecking=false" \
  -o "PasswordAuthentication=no" \
  -o "ServerAliveInterval 60" \
  -o "ServerAliveCountMax 3" \
  -R 10000:localhost:22 -p 2222 root@<EXTERNAL-IP>
```

## Troubleshooting

### Check pod status and logs:
```bash
kubectl get pods -l app=rsshd
kubectl logs deployment/rsshd
```

### Verify ConfigMap is mounted correctly:
```bash
kubectl exec deployment/rsshd -- cat /root/.ssh/authorized_keys
```

### Check SSH configuration:
```bash
kubectl exec deployment/rsshd -- cat /etc/ssh/sshd_config
```

### Test SSH connection:
```bash
# Test with verbose output for debugging
ssh -vv -p 2222 root@<EXTERNAL-IP>
```

### Common Issues

**Connection refused**: Check if the service has an external IP and the correct port.

**Permission denied (publickey)**: Verify your public key is correctly added to the ConfigMap.

**Host key verification failed**: This is normal on first connection. Use `-o StrictHostKeyChecking=no` to bypass.

## Security Notes

- **Key-based authentication only** - Password authentication is disabled
- **No persistent host keys** - SSH host keys are regenerated on pod restart
- **ConfigMap-based key management** - All authorized keys are stored in Kubernetes ConfigMap
- **Minimal privileges** - Container runs only necessary SSH services
