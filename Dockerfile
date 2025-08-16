FROM alpine:3.16.3
# 
# K8s-RsshD - Kubernetes SSH Reverse Tunnel Container
# Based on original work by Emmanuel Frecon <efrecon@gmail.com>
# 
# Copyright (c) 2016, Emmanuel Frecon
# Copyright (c) 2025, Alex Fedorino
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# See LICENSE file for full terms.
#

# Build arguments for versioning
ARG VERSION=dev
ARG BUILD_DATE
ARG VCS_REF

# Labels for metadata
LABEL org.opencontainers.image.title="K8s-RsshD" \
      org.opencontainers.image.description="Kubernetes-ready SSH reverse tunnel container" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.vendor="Alex Fedorino" \
      org.opencontainers.image.licenses="BSD-2-Clause" \
      org.opencontainers.image.source="https://github.com/fedorino-alex/k8s-rsshd" \
      org.opencontainers.image.documentation="https://github.com/fedorino-alex/k8s-rsshd/blob/master/README.md"

RUN apk --update add openssh
COPY sshd.sh /usr/local/bin/

# Expose the regular ssh port
EXPOSE 22
EXPOSE 80

ENTRYPOINT /usr/local/bin/sshd.sh
