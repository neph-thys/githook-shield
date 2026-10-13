
#!/usr/bin/env bash
set -eu

REPO_ROOT="$(git rev-parse --show-toplevel)"

cp "$REPO_ROOT/hooks/pre-commit" "$REPO_ROOT/.git/hooks/pre-commit"
chmod +x "$REPO_ROOT/.git/hooks/pre-commit"

echo "GitHook Shield hook installed."

