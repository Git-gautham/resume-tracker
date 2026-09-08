# setup_resume_repo.ps1
# Run this ONCE to prepare your machine. After this, use upload_resume.ps1
# (or upload_resume.bat) every time you want to push a resume update.
#
# EDIT THESE TWO LINES FIRST:
$RepoUrl  = "https://github.com/YOUR-USERNAME/YOUR-REPO.git"
$RepoPath = "C:\Users\YOUR-USERNAME\Repos\Resume"

$ErrorActionPreference = "Stop"

Write-Host "=== Step 1: Checking for Git ===" -ForegroundColor Cyan
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Error "Git is not installed. Get it from https://git-scm.com/download/win then re-run this script."
}
Write-Host "Git found: $(git --version)"

Write-Host "`n=== Step 2: Checking for GitHub CLI (gh) ===" -ForegroundColor Cyan
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI not found. Installing via winget..."
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements
        Write-Host "`nInstall finished. Close this window, open a NEW PowerShell window, and re-run this script (PATH needs to refresh)." -ForegroundColor Yellow
        exit
    } else {
        Write-Error "winget not found. Install GitHub CLI manually from https://cli.github.com/ then re-run this script."
    }
}
Write-Host "GitHub CLI found: $(gh --version | Select-Object -First 1)"

Write-Host "`n=== Step 3: Authenticating with GitHub ===" -ForegroundColor Cyan
$prevPref = $ErrorActionPreference
$ErrorActionPreference = "Continue"
gh auth status *> $null
$isLoggedIn = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $prevPref

if (-not $isLoggedIn) {
    Write-Host "Not logged in. Launching browser-based login..."
    gh auth login --hostname github.com --git-protocol https --web
} else {
    Write-Host "Already authenticated."
}

Write-Host "`n=== Step 4: Wiring git to use GitHub CLI credentials ===" -ForegroundColor Cyan
gh auth setup-git

Write-Host "`n=== Step 5: Cloning your repo ===" -ForegroundColor Cyan
if (Test-Path $RepoPath) {
    Write-Host "Repo already exists at $RepoPath, skipping clone."
} else {
    $parent = Split-Path $RepoPath -Parent
    if (-not (Test-Path $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    git clone $RepoUrl $RepoPath
}

Write-Host "`n=== Step 6: Verifying push access ===" -ForegroundColor Cyan
Push-Location $RepoPath
git pull
git push
Pop-Location

Write-Host "`nSetup complete. You can now run upload_resume.ps1 (or upload_resume.bat) any time." -ForegroundColor Green
