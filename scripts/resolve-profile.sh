#!/usr/bin/env bash
set -euo pipefail

username="${1:-$(id -un)}"

case "$username" in
  rtakeuchi)
    printf '%s\n' "work"
    ;;
  ren)
    printf '%s\n' "priv"
    ;;
  *)
    echo "no package profile configured for username: $username" >&2
    exit 2
    ;;
esac
