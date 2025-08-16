F# 
# K8s-RsshD - Kubernetes SSH Reverse Tunnel Container
# Based on original work by Emmanuel Frecon <efrecon@gmail.com>
# 
# Copyright (c) 2016, Emmanuel Frecon
# Copyright (c) 2025, Alex Fedorino
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# See LICENSE file for full terms.
#3.16.3
# 
# RsshD - Kubernetes SSH Reverse Tunnel Container
# Based on original work by Emmanuel Frecon <efrecon@gmail.com>
# 
# Copyright (c) 2016, Emmanuel Frecon
# Copyright (c) 2025, Aliaksandr Fedaryna
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# See LICENSE file for full terms.
#

RUN apk --update add openssh
COPY sshd.sh /usr/local/bin/

# Expose the regular ssh port
EXPOSE 22
EXPOSE 80

ENTRYPOINT /usr/local/bin/sshd.sh
