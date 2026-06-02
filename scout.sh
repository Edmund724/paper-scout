#!/usr/bin/env bash
# Launch a Paper Scout reading-agent run.
#
# Runs the reading agent from workspace/ with the date-stamped prompt.txt as its
# trigger. Adjust the final `exec` line if your harness/CLI is not Codex.
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_root/workspace"

today="$(date +%F)"
prompt="$(printf 'Today is %s.\n\n' "$today"; cat "$repo_root/prompt.txt")"

# Codex non-interactive run. Replace this line if you use a different CLI.
exec codex exec "$prompt"
