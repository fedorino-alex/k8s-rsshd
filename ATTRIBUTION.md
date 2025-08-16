# Attribution and License Information

## This Fork

**Repository**: https://github.com/fedorino-alex/k8s-rsshd
**Author**: Alex Fedorino  
**Focus**: Kubernetes-native SSH reverse tunneling

## Original Work

This project is based on the original RsshD by Emmanuel Frecon.

- **Original Author**: Emmanuel Frecon <efrecon@gmail.com>
- **Original Repository**: https://github.com/efrecon/rsshd
- **Original Copyright**: Copyright (c) 2016, Emmanuel Frecon
- **License**: BSD 2-Clause License

## Modifications

This fork includes significant modifications for Kubernetes deployment:
- Simplified SSH key management
- Key-based authentication only (enhanced security)
- ConfigMap integration for authorized keys
- Kubernetes deployment manifests
- Removed complex persistent storage requirements
- Container-native approach

## License Terms

This software is licensed under the BSD 2-Clause License. The full license text is available in the LICENSE file.

### Key Requirements:
- Redistributions of source code must retain the original copyright notice
- Redistributions in binary form must reproduce the copyright notice in documentation
- Software is provided "as is" without warranty

### Permissions:
- Commercial use
- Modification
- Distribution
- Private use

For complete license terms, see the LICENSE file in this repository.
