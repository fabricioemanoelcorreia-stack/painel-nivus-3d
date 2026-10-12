#!/usr/bin/env bash
# PostToolUse: after editing a UI file, remind Claude to check it against the Web Interface Guidelines.
f=$(jq -r '.tool_input.file_path // .tool_response.filePath // empty')
case "$f" in
  *.tsx|*.jsx|*.html|*.css|*.scss|*.vue|*.svelte|*.astro) ;;
  *) exit 0 ;;
esac
jq -n --arg f "$f" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:("UI file edited: " + $f + ". Before finishing, review it against .claude/commands/web-interface-guidelines.md (accessibility, focus, forms, animation, typography, performance, i18n, copy) and fix any violations you introduced.")}}'
