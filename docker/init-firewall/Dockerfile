FROM alpine:3.15

RUN apk add --update iptables curl bash

RUN mkdir /tmp/firewall
COPY start.sh /tmp/firewall/start.sh
RUN chmod +x /tmp/firewall/start.sh

ENTRYPOINT ["/tmp/firewall/start.sh"]
