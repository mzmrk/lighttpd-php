#!/bin/sh
set -e

# Location of Lighttpd's packaged log files (we replace them with FIFOs)
LOG_DIR=/var/log/lighttpd
ACCESS_PIPE="$LOG_DIR/access.log"
ERROR_PIPE="$LOG_DIR/error.log"

# ANSI color prefixes so each stream is easy to distinguish in docker logs
ACCESS_PREFIX=$(printf '\033[32m[access]\033[0m ')
ERROR_PREFIX=$(printf '\033[31m[error]\033[0m  ')

# Stream access log entries with a green prefix
(
    while true; do
        cat "$ACCESS_PIPE"
    done
) | sed -u "s/^/${ACCESS_PREFIX}/" &
ACCESS_TAIL_PID=$!

# Stream error log entries with a red prefix
(
    while true; do
        cat "$ERROR_PIPE"
    done
) | sed -u "s/^/${ERROR_PREFIX}/" &
ERROR_TAIL_PID=$!

# Drop privileges to www-data before launching Lighttpd in foreground mode
exec lighttpd -D -f /etc/lighttpd/lighttpd.conf
