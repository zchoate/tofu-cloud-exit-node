ARG CADDY_VERSION=2.10

FROM caddy:${CADDY_VERSION}-builder-alpine AS build

RUN mkdir -p /config/caddy /data/caddy
RUN xcaddy build \
        --with github.com/corazawaf/coraza-caddy/v2 \
        --with github.com/caddy-dns/cloudflare
RUN apk add -q --no-cache ca-certificates

FROM scratch

USER 1000

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

COPY --from=build --chown=1000 /config/caddy /config/caddy
COPY --from=build --chown=1000 /data/caddy /data/caddy
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --chown=1000 Caddyfile /etc/caddy/Caddyfile
COPY --from=build /usr/bin/caddy /usr/bin/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]