---
description: "Cancel active Ralph loop"
allowed-tools: ["Bash(powershell.exe -NoProfile -Command Remove-Item .claude/ralph-loop.local.md -Force -ErrorAction SilentlyContinue)"]
---

# Cancel Ralph

Check if Ralph loop is active and cancel it:

1. First check: powershell.exe -NoProfile -Command "if (Test-Path .claude/ralph-loop.local.md) { Get-Content .claude/ralph-loop.local.md -Head 5 } else { Write-Host 'NO_LOOP' }"

2. If file exists, run: powershell.exe -NoProfile -Command "Remove-Item .claude/ralph-loop.local.md -Force"

3. Report the result to the user.
