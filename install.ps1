# Ralph Wiggum Windows - Project-Level Installer
# Run this script from your project root directory

param(
    [switch]$Force,
    [switch]$KeepSource
)

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Ralph Wiggum Windows Installer" -ForegroundColor Cyan
Write-Host "  Project-Level Installation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if .claude folder exists
$claudeDir = ".claude"
$repoDir = "$claudeDir/ralph-wiggum-windows"

# Check if already installed
if ((Test-Path "$claudeDir/commands/ralph-loop.md") -and -not $Force) {
    Write-Host "[!] Ralph Wiggum appears to be already installed." -ForegroundColor Yellow
    Write-Host "    Use -Force to reinstall." -ForegroundColor Yellow
    Write-Host ""
    exit 0
}

# Step 1: Clone repository if not exists
Write-Host "[1/5] Cloning repository..." -ForegroundColor Green
if (Test-Path $repoDir) {
    Write-Host "      Repository already exists, pulling latest..." -ForegroundColor Gray
    Push-Location $repoDir
    git pull --quiet
    Pop-Location
} else {
    git clone --quiet https://github.com/mannnrachman/ralph-wiggum-windows $repoDir
}
Write-Host "      Done!" -ForegroundColor Gray

# Step 2: Create directories
Write-Host "[2/5] Creating directories..." -ForegroundColor Green
$dirs = @("$claudeDir/commands", "$claudeDir/hooks", "$claudeDir/scripts")
foreach ($dir in $dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "      Created: $dir" -ForegroundColor Gray
    }
}
Write-Host "      Done!" -ForegroundColor Gray

# Step 3: Copy files
Write-Host "[3/5] Copying files..." -ForegroundColor Green

# Commands
Copy-Item "$repoDir/commands/ralph-loop.md" "$claudeDir/commands/ralph-loop.md" -Force
Copy-Item "$repoDir/commands/cancel-ralph.md" "$claudeDir/commands/cancel-ralph.md" -Force
Copy-Item "$repoDir/commands/help-ralph.md" "$claudeDir/commands/help-ralph.md" -Force
Write-Host "      Copied commands" -ForegroundColor Gray

# Hooks
Copy-Item "$repoDir/hooks/stop-hook.ps1" "$claudeDir/hooks/stop-hook.ps1" -Force
Write-Host "      Copied hooks" -ForegroundColor Gray

# Scripts
Copy-Item "$repoDir/scripts/setup-ralph-loop.ps1" "$claudeDir/scripts/setup-ralph-loop.ps1" -Force
Write-Host "      Copied scripts" -ForegroundColor Gray

# Settings
Copy-Item "$repoDir/settings.local.json" "$claudeDir/settings.local.json" -Force
Write-Host "      Copied settings.local.json" -ForegroundColor Gray

Write-Host "      Done!" -ForegroundColor Gray

# Step 4: Verify installation
Write-Host "[4/5] Verifying installation..." -ForegroundColor Green
$requiredFiles = @(
    "$claudeDir/commands/ralph-loop.md",
    "$claudeDir/commands/cancel-ralph.md",
    "$claudeDir/commands/help-ralph.md",
    "$claudeDir/hooks/stop-hook.ps1",
    "$claudeDir/scripts/setup-ralph-loop.ps1",
    "$claudeDir/settings.local.json"
)

$allPresent = $true
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "      Missing: $file" -ForegroundColor Red
        $allPresent = $false
    }
}

if ($allPresent) {
    Write-Host "      All files verified!" -ForegroundColor Gray
}

# Step 5: Cleanup source repository
Write-Host "[5/5] Cleaning up..." -ForegroundColor Green
if (-not $KeepSource) {
    if (Test-Path $repoDir) {
        Remove-Item -Path $repoDir -Recurse -Force
        Write-Host "      Removed source repository" -ForegroundColor Gray
    }
    Write-Host "      Done!" -ForegroundColor Gray
} else {
    Write-Host "      Skipped (keeping source)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Available commands:" -ForegroundColor White
Write-Host "  /ralph-loop    - Start a Ralph loop" -ForegroundColor Gray
Write-Host "  /cancel-ralph  - Cancel active loop" -ForegroundColor Gray
Write-Host "  /help-ralph    - Show help" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart Claude Code VSCode extension or CLI" -ForegroundColor Gray
Write-Host "  2. Try: /ralph-loop ""Your task here"" --max-iterations 10" -ForegroundColor Gray
Write-Host ""
