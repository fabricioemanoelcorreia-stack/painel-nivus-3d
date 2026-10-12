#!/usr/bin/env bash
# PostToolUse: after editing a UI file, remind Claude to check it against the Web Interface Guidelines.
# Plain bash (no jq) so it also runs under Git Bash on Windows. The path is kept JSON-escaped as received.
f=$(sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\(\([^"\\]\|\\.\)*\)".*/\1/p' | head -n 1)
case "$f" in
  *.tsx|*.jsx|*.html|*.css|*.scss|*.vue|*.svelte|*.astro) ;;
  *) exit 0 ;;
esac
printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"UI file edited: %s. Before finishing, review it against the web-interface-guidelines skill/command of nivus-kit (accessibility, focus, forms, animation, typography, performance, i18n, copy) and fix any violations you introduced."}}' "$f"
