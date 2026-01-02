---
description: "Start Ralph loop in current session"
argument-hint: "PROMPT [--max-iterations N] [--completion-promise TEXT]"
allowed-tools: ["Bash(powershell.exe -NoProfile -ExecutionPolicy Bypass -File .claude/scripts/setup-ralph-loop.ps1 *)"]
---

STEP 1 - MANDATORY: Execute this Bash command IMMEDIATELY to initialize the Ralph loop:

powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".claude/scripts/setup-ralph-loop.ps1" $ARGUMENTS

STEP 2: After executing the script above, work on the task from the prompt.

When you try to exit, the Ralph loop stop hook will intercept and feed the SAME PROMPT back to you for the next iteration. You'll see your previous work in files and git history, allowing you to iterate and improve.

CRITICAL RULE: If a completion promise is set, you may ONLY output it when the statement is completely and unequivocally TRUE. Do not output false promises to escape the loop. Use exact format: <promise>YOUR_PROMISE_TEXT</promise>
