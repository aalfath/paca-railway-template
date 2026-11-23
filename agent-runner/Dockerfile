# Paca agent runner (Go): brokers ACP-type AI agents (your own Claude Code, Codex,
# Gemini CLI or Goose, connected with paca-acp-bridge) and serves the LLM model
# catalogue. Pinned by version and digest.
#
# Railway has no Docker socket, so the runner cannot start the per-conversation
# Goose sandbox containers that "LLM"-type agents use; see README.md.
FROM pacaai/paca-agent-runner:0.22.0@sha256:ac7f91766ccca762a9382dd6ac335e446f31d651e114830f5c545477c86f2ac4

ENV HTTP_ADDR=:8080 \
    PORT=8080 \
    AGENT_SERVER_IMAGE=ghcr.io/paca-ai/paca-agent-server-goose:0.22.0 \
    AGENT_RUNNER_ALLOWED_AGENT_IDS=* \
    SANDBOX_DOCKER_IN_SANDBOX=false \
    WORKER_CONCURRENCY=2 \
    ENVIRONMENT_PROVISION_CONCURRENCY=1 \
    LOG_LEVEL=info \
    GOMAXPROCS=2
COPY --chmod=755 start.sh /usr/local/bin/railway-start.sh
EXPOSE 8080
CMD ["/usr/local/bin/railway-start.sh"]
