# Changelog

## 0.22.0 (2026-11-23)

- First release of the template: Paca v0.22.0 (`pacaai/paca-api`, `paca-web`, `paca-realtime`, `paca-agent-runner` 0.22.0, pinned by digest), RustFS 1.0.6, Railway Postgres and Railway Redis.
- Admin account `admin` with a generated password; generated JWT, encryption, internal and storage keys.
- Plugins are stored in the RustFS bucket (`PLUGINS_STORE=s3`). LLM-agent sandboxes and environments are off (no Docker socket on Railway); ACP agents work.
