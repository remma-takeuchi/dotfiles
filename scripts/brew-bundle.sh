#!/usr/bin/env bash
set -euo pipefail

mode="${1:---no-upgrade}"
case "$mode" in
  --check|--no-upgrade|--upgrade) ;;
  *)
    echo "usage: $0 [--check|--no-upgrade|--upgrade]" >&2
    exit 2
    ;;
esac

if command -v brew >/dev/null 2>&1; then
  :
elif [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
else
  echo "brew not found; install Homebrew before syncing packages" >&2
  exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="$(cd "$script_dir/../config" && pwd)"
profile="${CHEZMOI_PROFILE:-}"

# Third-party taps require explicit trust before `brew bundle` can load their
# formulae/casks. Trust any tap declared in a Brewfile up front so re-runs
# (e.g. on a fresh machine) never fail on an "untrusted tap" error.
trust_taps() {
  local brewfile="$1"
  [ -f "$brewfile" ] || return 0

  grep -E '^\s*tap\s+"' "$brewfile" | sed -E 's/^\s*tap\s+"([^"]+)".*/\1/' | while IFS= read -r tap; do
    brew trust --tap "$tap" >/dev/null 2>&1 || true
  done
}

run_bundle() {
  local brewfile="$1"

  case "$mode" in
    --check)
      brew bundle check --file "$brewfile"
      ;;
    --no-upgrade)
      brew bundle --no-upgrade --file "$brewfile"
      ;;
    --upgrade)
      brew bundle upgrade --file "$brewfile"
      ;;
  esac
}

trust_taps "$config_dir/Brewfile.common"
run_bundle "$config_dir/Brewfile.common"

case "$(uname -s)" in
  Darwin)
    trust_taps "$config_dir/Brewfile.darwin"
    run_bundle "$config_dir/Brewfile.darwin"
    case "$profile" in
      work)
        trust_taps "$config_dir/Brewfile.darwin.work"
        run_bundle "$config_dir/Brewfile.darwin.work"
        ;;
      priv)
        trust_taps "$config_dir/Brewfile.darwin.priv"
        run_bundle "$config_dir/Brewfile.darwin.priv"
        ;;
      "") ;;
      *)
        echo "unknown CHEZMOI_PROFILE: $profile (expected work or priv)" >&2
        exit 2
        ;;
    esac

    if [ "$mode" != "--check" ] && brew --prefix fzf >/dev/null 2>&1; then
      fzf_install="$(brew --prefix fzf)/install"
      if [ -x "$fzf_install" ]; then
        "$fzf_install" --key-bindings --completion --no-update-rc
      fi
    fi
    ;;
  Linux)
    trust_taps "$config_dir/Brewfile.linux"
    run_bundle "$config_dir/Brewfile.linux"
    ;;
  *)
    echo "unsupported operating system: $(uname -s)" >&2
    exit 2
    ;;
esac
