# Paca realtime service (Bun + Socket.IO): live board updates and collaborative
# editing, reached by browsers through the gateway's /ws path. Pinned by digest.
FROM pacaai/paca-realtime:0.22.0@sha256:dff495a78f4c26aeb75866221e72a2beefd36c3700d230dd73fc85011235d036

ENV PORT=3001 \
    NODE_ENV=production \
    LOG_LEVEL=info
EXPOSE 3001
CMD ["bun", "run", "src/index.ts"]
