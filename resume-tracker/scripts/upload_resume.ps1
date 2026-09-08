# upload_resume.ps1
# Run this any time you want to push an updated resume to GitHub.
# Requires setup_resume_repo.ps1 to have been run once already.
#
# EDIT THESE THREE LINES FIRST:
$RepoPath   = "C:\Users\YOUR-USERNAME\Repos\Resume"
$SourceDocx = "C:\Users\YOUR-USERNAME\Downloads\YOUR-RESUME.docx"
$SourcePdf  = "C:\Users\YOUR-USERNAME\Downloads\YOUR-RESUME.pdf"

$ErrorActionPreference = "Stop"

if (-not (Test-Path $RepoPath)) {
    Write-Error "Repo folder not found at $RepoPath. Run setup_resume_repo.ps1 first."
}

if (-not (Test-Path $SourceDocx)) {
    Write-Error "Docx not found at $SourceDocx"
}

if (-not (Test-Path $SourcePdf)) {
    Write-Error "PDF not found at $SourcePdf"
}

Copy-Item -Path $SourceDocx -Destination $RepoPath -Force
Copy-Item -Path $SourcePdf  -Destination $RepoPath -Force

Push-Location $RepoPath

git pull --rebase

git add "*.docx" "*.pdf"

$staged = git diff --cached --name-only

if ([string]::IsNullOrWhiteSpace($staged)) {
    Write-Host "No changes detected - resume is already up to date in the repo."
}
else {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
    git commit -m "Update resume - $timestamp"
    git push
    Write-Host "Resume updated and pushed to GitHub."
}

Pop-Location
