# Paca API (Go): REST API, database migrations (run on every start), the admin
# seed and background workers. Official image, pinned by version and digest.
FROM pacaai/paca-api:0.22.0@sha256:299499ec9ada80ccd9c6658b3a59722844088fd733d44b5ce8873939abd501cb

# Fixed settings for Railway. Secrets and service addresses come from template variables.
ENV ENV=production \
    PORT=8080 \
    COOKIE_SECURE=true \
    TRUSTED_PROXY_HOPS=1 \
    ADMIN_USERNAME=admin \
    STORAGE_PROVIDER=rustfs \
    STORAGE_BUCKET=paca \
    STORAGE_REGION=us-east-1 \
    STORAGE_USE_SSL=false \
    PLUGINS_STORE=s3 \
    SANDBOX_DOCKER_IN_SANDBOX=false \
    GOMAXPROCS=2

COPY --chmod=755 start.sh /usr/local/bin/railway-start.sh
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
