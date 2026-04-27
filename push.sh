#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
REMOTE_NAME="origin"
BRANCH="main"

cd "$DOTFILES_DIR" || { echo "Error: $DOTFILES_DIR not found"; exit 1; }

if [ ! -d ".git" ]; then
    echo "[init] Creating git repository..."
    git init -b "$BRANCH"
    echo ""
    echo "  Next step: add your GitHub remote:"
    echo "    cd $DOTFILES_DIR"
    echo "    git remote add origin git@github.com:<USER>/<REPO>.git"
    echo ""
fi

if [ -z "$(git remote get-url $REMOTE_NAME 2>/dev/null)" ]; then
    echo "[warn] No remote '$REMOTE_NAME' configured."
    echo "  Run: git remote add origin git@github.com:<USER>/<REPO>.git"
    echo "  Then re-run this script."
    exit 1
fi

MSG="${1:-backup $(date '+%Y-%m-%d %H:%M:%S')}"

echo "[stage] Adding all changes..."
git add -A

STAGED=$(git diff --cached --name-only)
if [ -z "$STAGED" ]; then
    echo "[skip] No changes to commit."
    exit 0
fi

echo "[commit] $MSG"
git commit -m "$MSG"

echo "[push] Pushing to $REMOTE_NAME/$BRANCH..."
git push -u "$REMOTE_NAME" "$BRANCH"

echo ""
echo "=== Done! ==="
