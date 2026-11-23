[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/paca-1?utm_medium=integration&utm_source=button&utm_campaign=paca)

# Paca on Railway

One-click Railway template for [Paca](https://github.com/Paca-AI/paca) **v0.22.0**, the open-source (Apache-2.0), AI-native project management app: Scrum boards, backlogs, sprints, docs and files, where AI agents can be project members next to people.

Every app service builds from this repository, so Railway tells deployers when we publish a new version.

## What you get

| Service | Folder | Image (pinned by digest) | What it does |
|---|---|---|---|
| **Paca** | `paca/` | `pacaai/paca-web:0.22.0` | Public. Serves the web app and routes `/api`, `/ws`, `/storage`, `/plugins*` and the agent bridge to the private services (Caddy). Health check `/healthz`. |
| **API** | `api/` | `pacaai/paca-api:0.22.0` | Go REST API. Runs the database migrations on every start, creates the admin account, runs the background workers. Health check `/api/healthz`. |
| **Realtime** | `realtime/` | `pacaai/paca-realtime:0.22.0` | Socket.IO service for live board updates and collaborative editing. Health check `/healthz`. |
| **Agents** | `agent-runner/` | `pacaai/paca-agent-runner:0.22.0` | Paca's agent runner: brokers ACP agents (your own Claude Code, Codex, Gemini CLI, Goose or OpenCode) and serves the model catalogue. Health check `/llm/models`. |
| **RustFS** | `rustfs/` | `rustfs/rustfs:1.0.6` | Private S3-compatible storage for attachments, files, avatars, exports and plugins, on a volume at `/data`. Health check `/health`. |
| **Postgres** | Railway database | Railway Postgres | Projects, tasks, docs, users. |
| **Redis** | Railway database | Railway Redis | Sessions, caches, event streams between the services. |

## After deploy

1. Open the **Paca** service's public URL.
2. Sign in as `admin`. The password is the `ADMIN_PASSWORD` variable on the **Paca** service (generated for your deploy).
3. Change the password under your profile, then invite your team (there is no open sign-up).

### AI agents

- **ACP agents (work on Railway).** Create an agent of type *ACP* in a project, then run Paca's `paca-acp-bridge` on your own machine in your code folder. The bridge connects to `wss://YOUR-DOMAIN/agent-bridge/ws` and runs your own Claude Code, Codex, Gemini CLI, Goose or OpenCode with your own login. See [apps/acp-bridge](https://github.com/Paca-AI/paca/tree/v0.22.0/apps/acp-bridge).
- **MCP server and skills.** Create an API key in Paca, then point Paca's MCP server (`npx -y @paca-ai/paca-mcp` with `PACA_API_URL=https://YOUR-DOMAIN` and `PACA_API_KEY`) or the Paca skills at your instance.
- **Project AI features** (Jev decisions, task autofill) use a key you add per project under Settings. Nothing is sent to an AI provider unless you add a key.
- **Not available on Railway: "LLM" agents and static environments.** Upstream runs each LLM-agent conversation and each environment in its own Docker container through the host's Docker socket (or on Kubernetes). Railway has no Docker socket, so those features stay off here (`SANDBOX_DOCKER_IN_SANDBOX=false`). Use ACP agents instead.

## Variables

All values are generated or wired by the template; nothing needs to be typed in.

| Service | Variable | Value |
|---|---|---|
| Paca | `ADMIN_USERNAME`, `ADMIN_PASSWORD` | `admin` and a generated password (the API reads them from here) |
| Paca | `API_UPSTREAM`, `REALTIME_UPSTREAM`, `AGENT_RUNNER_UPSTREAM`, `STORAGE_UPSTREAM` | private addresses of the other services |
| API | `JWT_SECRET`, `ENCRYPTION_KEY`, `AI_AGENT_INTERNAL_KEY` | generated secrets (`ENCRYPTION_KEY` encrypts stored AI keys: keep it) |
| API | `DATABASE_URL`, `REDIS_URL`, `STORAGE_*`, `PUBLIC_URL`, `AI_AGENT_URL` | references to Postgres, Redis, RustFS and the public domain |
| Realtime | `API_URL`, `REDIS_URL`, `CORS_ORIGINS` | references |
| Agents | `DATABASE_URL`, `VALKEY_URL`, `ENCRYPTION_KEY`, `INTERNAL_API_KEY`, `PACA_API_URL`, `PACA_GATEWAY_URL` | references (shared secrets come from the API service) |
| RustFS | `RUSTFS_ACCESS_KEY`, `RUSTFS_SECRET_KEY` | generated S3 credentials |

Optional settings you can add later on the **API** service: SMTP for e-mail, SSO/OIDC, `PASSKEY_RP_ID`. See Paca's [deployment docs](https://github.com/Paca-AI/paca/blob/v0.22.0/deploy/README.md).

## Resources

Each service fits Railway's Free/Trial limit of 0.5 GB RAM. Idle use is small (API, Agents and Paca under 50 MB each, Realtime about 40 MB). Go services cap their heap at 70% of the service's memory limit.

## Updates

Paca's images are pinned by version and digest in each folder's `Dockerfile`. When we bump them here, Railway shows an "update available" notice on your project; read `CHANGELOG.md` first, then apply it. Database migrations run automatically when the API starts.

## What's left out from upstream's Compose file

- `db-backup` (cron `pg_dump` to a host folder): use Railway's Postgres backups instead.
- The LLM-agent sandbox containers and static environments, SSH bastion and port forwarding: they need the Docker socket.
- A separate Valkey: Railway Redis is used instead.

## Licence

The wrapper files in this repository are MIT. Paca is Apache-2.0, RustFS is Apache-2.0 and Caddy is Apache-2.0.
