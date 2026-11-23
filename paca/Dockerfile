# Paca web app + gateway: the official paca-web image (Caddy serving the built SPA)
# with a Railway Caddyfile that also routes /api, /ws, /storage and the agent
# bridge to the private services, like upstream's deploy/caddy gateway.
FROM pacaai/paca-web:0.22.0@sha256:de4305eebca9281418f6e0c373f3e47956634bb1d2a5ee2002a324b78afb6ae2

COPY Caddyfile /etc/caddy/Caddyfile

ENV PORT=8080
EXPOSE 8080
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
