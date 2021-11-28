#!/usr/bin/env bash

set -x
set -eo pipefail

#PROXY_PORT=1080
#INBOUND_PROXY_PORT=1080
OUTBOUND_PROXY_PORT=1080

iptables-restore -n <<EOF
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:PROXY_INBOUND - [0:0]
:PROXY_IN_REDIRECT - [0:0]
:PROXY_OUTPUT - [0:0]
:PROXY_REDIRECT - [0:0]

# Route all input traffic to PROXY_INBOUND
#-A PREROUTING -p tcp -j PROXY_INBOUND

# Route all output traffic to PROXY_OUTPUT
-A OUTPUT -p tcp -j PROXY_OUTPUT

#-A PROXY_INBOUND -p tcp -m tcp --dport 22 -j RETURN
#-A PROXY_INBOUND -p tcp -m tcp --dport ${PROXY_PORT} -j RETURN
#-A PROXY_INBOUND -p tcp -m tcp --dport 15020 -j RETURN
#-A PROXY_INBOUND -p tcp -j PROXY_IN_REDIRECT
#-A PROXY_IN_REDIRECT -p tcp -j REDIRECT --to-ports ${INBOUND_PROXY_PORT}

# do not redirect traffic inside of the container
-A PROXY_OUTPUT -s 127.0.0.6/32 -o lo -j RETURN

# do not redirect traffic from proxy itself/ by uid
-A PROXY_OUTPUT ! -d 127.0.0.1/32 -o lo -m owner --uid-owner 1337 -j PROXY_IN_REDIRECT
-A PROXY_OUTPUT -o lo -m owner ! --uid-owner 1337 -j RETURN
-A PROXY_OUTPUT -m owner --uid-owner 1337 -j RETURN

# do not redirect traffic from proxy itself/ by gid
-A PROXY_OUTPUT ! -d 127.0.0.1/32 -o lo -m owner --gid-owner 1337 -j PROXY_IN_REDIRECT
-A PROXY_OUTPUT -o lo -m owner ! --gid-owner 1337 -j RETURN
-A PROXY_OUTPUT -m owner --gid-owner 1337 -j RETURN
-A PROXY_OUTPUT -d 127.0.0.1/32 -j RETURN

-A PROXY_OUTPUT -j PROXY_REDIRECT
-A PROXY_REDIRECT -p tcp -j REDIRECT --to-ports ${OUTBOUND_PROXY_PORT}
COMMIT
EOF

echo "Applied iptables-save file:"
iptables-save

echo "Active firewall rules:"
iptables -L -t nat -v
