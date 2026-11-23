#!/bin/sh
# Wait until the Paca API answers /api/healthz (it runs the database migrations
# before it listens), then start the runner. Exits non-zero on timeout or crash
# so Railway's ON_FAILURE policy restarts the service.
set -eu
: "${PACA_API_URL:?PACA_API_URL is required}"

if [ -z "${GOMEMLIMIT:-}" ] && [ -r /sys/fs/cgroup/memory.max ]; then
  lim=$(cat /sys/fs/cgroup/memory.max)
  case "$lim" in
    ''|max) ;;
    *) export GOMEMLIMIT="$((lim * 7 / 10 / 1048576))MiB" ;;
  esac
fi

i=0
until wget -q -T 3 -O /dev/null "${PACA_API_URL}/api/healthz" 2>/dev/null; do
  i=$((i + 1))
  if [ "$i" -ge 100 ]; then echo "railway-start: Paca API (${PACA_API_URL}) not ready after 5 minutes" >&2; exit 1; fi
  sleep 3
done

exec ./agent-runner
