# Ralph Wiggum Plugin for Windows (Project-Level Installation)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows](https://img.shields.io/badge/Platform-Windows-blue.svg)](https://www.microsoft.com/windows)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Plugin-purple.svg)](https://claude.ai/code)

A Windows-compatible [Claude Code](https://claude.ai/code) plugin implementing the **Ralph Wiggum technique** - iterative, self-referential AI development loops using PowerShell.

> *"Me fail English? That's unpossible!"* - Ralph Wiggum

---

## What is the Ralph Wiggum Technique?

The Ralph Wiggum technique, pioneered by [Geoffrey Huntley](https://ghuntley.com/ralph/), is an iterative development methodology based on continuous AI loops:

```powershell
while ($true) {
  Get-Content PROMPT.md | claude --continue
}
```

**Core concept**: The same prompt is fed to Claude repeatedly. Claude sees its own previous work in files and git history, allowing it to iteratively improve until the task is complete.

### How It Works

1. You start a Ralph loop with a task prompt
2. Claude works on the task, modifying files
3. When Claude tries to exit, the **stop hook intercepts**
4. The **same prompt** is fed back to Claude
5. Claude sees its previous work and continues improving
6. Loop continues until completion criteria are met

---

## Installation (Project-Level)

This installation uses **project-level** (local) setup, meaning Ralph Wiggum will only be active in this specific project, not globally across all projects.

### Option 1: Automatic Installation (Recommended)

Open **PowerShell** in your project directory and run:

```powershell
# Download and run installer
irm https://raw.githubusercontent.com/mannnrachman/ralph-wiggum-windows/main/install.ps1 | iex
```

Or if you've already cloned the repository:

```powershell
# Run installer from cloned repo
powershell -ExecutionPolicy Bypass -File .claude/ralph-wiggum-windows/install.ps1
```

The installer will automatically:
- Clone the repository (if needed)
- Create required directories
- Copy all files to the correct locations
- Verify the installation
- Remove the source repository (cleanup)

> **Note:** Use `-KeepSource` flag to keep the source repository after installation.

---

### Option 2: Manual Installation

If you prefer to install manually, follow these steps:

#### Step 1: Clone Repository to Your Project

```powershell
# Navigate to your project directory
cd C:\path\to\your\project

# Clone to .claude folder inside your project
git clone https://github.com/mannnrachman/ralph-wiggum-windows .claude/ralph-wiggum-windows
```

#### Step 2: Copy Files to the Correct Structure

After cloning, copy the required files:

```powershell
# Create required folders
mkdir -p .claude/commands
mkdir -p .claude/hooks
mkdir -p .claude/scripts

# Copy commands (rename as needed)
cp .claude/ralph-wiggum-windows/commands/ralph-loop.md .claude/commands/ralph-loop.md
cp .claude/ralph-wiggum-windows/commands/cancel-ralph.md .claude/commands/cancel-ralph.md
cp .claude/ralph-wiggum-windows/commands/help.md .claude/commands/help-ralph.md

# Copy hooks and scripts
cp .claude/ralph-wiggum-windows/hooks/stop-hook.ps1 .claude/hooks/stop-hook.ps1
cp .claude/ralph-wiggum-windows/scripts/setup-ralph-loop.ps1 .claude/scripts/setup-ralph-loop.ps1

# Copy hooks configuration
cp .claude/ralph-wiggum-windows/settings.local.json .claude/settings.local.json
```

#### Step 3: Cleanup (Optional)

Remove the source repository to save space:

```powershell
# Remove source repository (no longer needed)
rm -r .claude/ralph-wiggum-windows
```

#### Step 4: Restart Claude Code

Restart Claude Code VSCode extension or CLI so the commands are detected.

---

### Verify Installation

After installation, the following commands will be available:
- `/ralph-loop` - Start a Ralph loop
- `/cancel-ralph` - Cancel active loop
- `/help-ralph` - Show help

---

## File Structure After Installation

```
your-project/
├── .claude/
│   ├── commands/
│   │   ├── ralph-loop.md       # /ralph-loop command
│   │   ├── cancel-ralph.md     # /cancel-ralph command
│   │   └── help-ralph.md       # /help-ralph command
│   ├── hooks/
│   │   └── stop-hook.ps1       # Stop hook (PowerShell)
│   ├── scripts/
│   │   └── setup-ralph-loop.ps1    # Setup script
│   └── settings.local.json     # Project-level hooks configuration
└── ... (other project files)
```

---

## Quick Start

```
/ralph-loop "Build a REST API for todos with CRUD operations" --completion-promise "DONE" --max-iterations 30
```

---

## Commands

### `/ralph-loop`

Start a Ralph loop in your current session.

**Usage:**
```
/ralph-loop "<prompt>" [--max-iterations N] [--completion-promise "<text>"]
```

**Options:**
| Option | Description | Default |
|--------|-------------|---------|
| `--max-iterations <n>` | Maximum iterations before auto-stop | unlimited |
| `--completion-promise <text>` | Phrase that signals successful completion | none |

**Examples:**
```bash
# Run until "DONE" is achieved, max 50 iterations
/ralph-loop "Refactor the cache layer for better performance" --completion-promise "DONE" --max-iterations 50

# Run for exactly 10 iterations
/ralph-loop "Explore optimization opportunities" --max-iterations 10

# Run indefinitely (use with caution!)
/ralph-loop "Continuously improve test coverage"
```

### `/cancel-ralph`

Cancel an active Ralph loop immediately.

```
/cancel-ralph
```

### `/help-ralph`

Display comprehensive help about the Ralph Wiggum technique and all available commands.

```
/help-ralph
```

---

## Completion Promises

To signal that a task is complete, Claude must output a `<promise>` tag:

```
<promise>TASK COMPLETE</promise>
```

**Important rules:**
- The promise text must match exactly what you specified in `--completion-promise`
- Claude should only output the promise when the statement is genuinely true
- The stop hook specifically looks for `<promise>...</promise>` tags

---

## Monitoring Your Loop

While a Ralph loop is running, you can check its status:

```powershell
# View current iteration
Select-String '^iteration:' .claude/ralph-loop.local.md

# View full state
Get-Content .claude/ralph-loop.local.md -Head 10
```

---

## When to Use Ralph

### Good Use Cases

- **Well-defined tasks** with clear success criteria
- **Iterative development** requiring refinement cycles
- **Greenfield projects** where Claude can build incrementally
- **Refactoring tasks** with measurable outcomes
- **Test coverage** improvements

### Not Recommended For

- Tasks requiring human judgment or design decisions
- One-shot operations (just use Claude normally)
- Tasks with unclear or subjective success criteria
- Debugging production issues (need human oversight)
- Tasks where you need to provide frequent feedback

---

## Global vs Project-Level Installation

| Aspect | Global (`~/.claude/`) | Project (`./.claude/`) |
|--------|----------------------|------------------------|
| **Location** | `C:\Users\<user>\.claude\plugins\` | `<project>\.claude\` |
| **Scope** | All projects on computer | This project only |
| **Commands** | `/ralph-wiggum:ralph-loop` | `/ralph-loop` |
| **Recommended** | If you want to use across all projects | If you only need it for specific project |

**This documentation uses Project-Level Installation.**

---

## Windows Compatibility

This fork was created specifically for Windows users. The [original Ralph Wiggum plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum) uses bash/jq which don't work natively on Windows.

**Changes from the original:**
| Original (Unix) | This Fork (Windows) |
|-----------------|---------------------|
| `stop-hook.sh` | `stop-hook.ps1` |
| `jq` for JSON parsing | `ConvertFrom-Json` |
| bash scripts | PowerShell scripts |
| Unix path conventions | Windows path conventions |

---

## Troubleshooting

### Loop not starting
- Verify files exist in `.claude/commands/`, `.claude/hooks/`, `.claude/scripts/`
- Check that `.claude/settings.local.json` exists with correct hooks config
- Restart Claude Code

### Loop not stopping
- Use `/cancel-ralph` to force stop
- Manually delete `.claude/ralph-loop.local.md` in your project directory

### PowerShell execution policy errors
Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Commands not detected
- Make sure `.md` files exist in `.claude/commands/`
- Restart Claude Code VSCode extension
- Check frontmatter format in command files

### Debug Logging

The stop hook writes debug logs to `.claude/ralph-debug.log`. Check this file to diagnose issues:

```powershell
# View debug log
Get-Content .claude/ralph-debug.log

# Watch log in real-time
Get-Content .claude/ralph-debug.log -Wait -Tail 20
```

The log includes:
- Hook trigger events
- State file parsing results
- Iteration tracking
- Error messages with details

---

## Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Credits

- **Original technique**: [Geoffrey Huntley](https://ghuntley.com/ralph/)
- **Original plugin**: [Anthropic Claude Code team](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- **Windows fork**: CloudBuild Team

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

### v1.1.0 (Latest)

**Bug Fixes:**
- Fixed `ralph-loop.md` path issue: Changed from `${CLAUDE_PLUGIN_ROOT}` to relative path `.claude/scripts/setup-ralph-loop.ps1`
- Fixed argument parsing in `setup-ralph-loop.ps1` when Claude Code passes all arguments as a single string
- Simplified `cancel-ralph.md` command logic

**Improvements:**
- Added debug logging to `stop-hook.ps1` - logs written to `.claude/ralph-debug.log`
- Added `/help-ralph` command for comprehensive documentation
- Completion promise instructions now displayed after setup script runs
- Removed `hide-from-slash-command-tool` flag so commands are visible

### v1.0.0

- Initial release with Windows PowerShell support

---

## Related Links

- [Ralph Wiggum Technique (ghuntley.com)](https://ghuntley.com/ralph/)
- [Original Ralph Wiggum Plugin](https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [Windows compatibility issue #14817](https://github.com/anthropics/claude-code/issues/14817)
