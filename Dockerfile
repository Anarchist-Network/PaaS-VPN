FROM alpine:3.18.3

RUN apk add python3 py3-pip
RUN pip install flask

# Setup tailscale
WORKDIR /tailscale.d

COPY start.sh /tailscale.d/start.sh
COPY uptime.py /tailscale.d/uptime.py

ENV TAILSCALE_VERSION "latest"
ENV TAILSCALE_HOSTNAME "paas-vpn"
ENV TAILSCALE_ADDITIONAL_ARGS ""

RUN wget https://pkgs.tailscale.com/stable/tailscale_${TAILSCALE_VERSION}_amd64.tgz && \
  tar xzf tailscale_${TAILSCALE_VERSION}_amd64.tgz --strip-components=1

RUN apk update && apk add ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

RUN chmod +x ./start.sh
RUN chmod +x ./uptime.py
CMD ["./start.sh"]
