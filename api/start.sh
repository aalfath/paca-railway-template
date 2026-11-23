#!/bin/sh
# Wait for Postgres and RustFS on the private network (their DNS names can lag
# for the first minute of a new project), then start upstream's entrypoint.
# Any failure exits non-zero so Railway's ON_FAILURE policy restarts the API.
set -eu

: "${DATABASE_URL:?DATABASE_URL is required}"
: "${STORAGE_ENDPOINT:?STORAGE_ENDPOINT is required}"

# Go keeps its heap under ~70% of the container's memory limit.
if [ -z "${GOMEMLIMIT:-}" ] && [ -r /sys/fs/cgroup/memory.max ]; then
  lim=$(cat /sys/fs/cgroup/memory.max)
  case "$lim" in
    ''|max) ;;
    *) export GOMEMLIMIT="$((lim * 7 / 10 / 1048576))MiB" ;;
  esac
fi

hostport=$(printf '%s' "$DATABASE_URL" | sed -E 's#^[a-z]+://([^@]*@)?([^/?]+).*#\2#')
dbport=${hostport##*:}
dbhost=${hostport%:*}
dbhost=${dbhost#[}; dbhost=${dbhost%]}
[ "$dbport" = "$hostport" ] && dbport=5432

i=0
until nc -z -w 3 "$dbhost" "$dbport" 2>/dev/null; do
  i=$((i + 1))
  if [ "$i" -ge 60 ]; then echo "railway-start: Postgres ($dbhost:$dbport) not reachable after 3 minutes" >&2; exit 1; fi
  sleep 3
done

i=0
until wget -q -T 3 -O /dev/null "http://${STORAGE_ENDPOINT}/health" 2>/dev/null; do
  i=$((i + 1))
  if [ "$i" -ge 60 ]; then echo "railway-start: RustFS (${STORAGE_ENDPOINT}) not reachable after 3 minutes" >&2; exit 1; fi
  sleep 3
done

exec /usr/local/bin/docker-entrypoint.sh ./api
