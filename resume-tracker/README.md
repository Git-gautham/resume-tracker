# Resume Tracker

Keep a version history of your resume on GitHub. Every time you update your
resume, run one script — it copies the file(s) into this repo, commits, and
pushes. GitHub then keeps every past version, so you can always go back.

## Folder structure

```
resume-tracker/
├── README.md
├── scripts/
│   ├── setup_resume_repo.ps1   # run once
│   ├── upload_resume.ps1       # run every time you update your resume
│   └── upload_resume.bat       # double-click launcher for the script above
├── GAUTHAM P NAIR - Resume.docx   ← your resume files live here after setup
└── GAUTHAM P NAIR - Resume.pdf
```

Your actual resume files are **not** in this repo yet — the scripts copy them
in from wherever you keep the working copy (e.g. Downloads).

## One-time setup

1. Install [Git for Windows](https://git-scm.com/download/win) if you don't
   have it.
2. Open `scripts/setup_resume_repo.ps1` in a text editor and edit the top two
   lines:
   ```powershell
   $RepoUrl  = "https://github.com/YOUR-USERNAME/YOUR-REPO.git"
   $RepoPath = "C:\Users\YOUR-USERNAME\Repos\Resume"
   ```
   `$RepoUrl` is this repo's clone URL (Code → Copy, on GitHub).
   `$RepoPath` is where you want the repo to live on your PC.
3. Run it:
   ```powershell
   powershell -ExecutionPolicy Bypass -File setup_resume_repo.ps1
   ```
   This installs GitHub CLI if needed, logs you into GitHub in your browser,
   and clones the repo to `$RepoPath`.

   If it installs GitHub CLI for the first time, it will ask you to open a
   **new** PowerShell window and run it again (Windows needs to refresh its
   PATH after installing a new program).

## Every time you update your resume

1. Open `scripts/upload_resume.ps1` in a text editor and edit the top three
   lines to match your setup:
   ```powershell
   $RepoPath   = "C:\Users\YOUR-USERNAME\Repos\Resume"
   $SourceDocx = "C:\Users\YOUR-USERNAME\Downloads\YOUR-RESUME.docx"
   $SourcePdf  = "C:\Users\YOUR-USERNAME\Downloads\YOUR-RESUME.pdf"
   ```
   (You only need to do this once — after that, the same file paths are
   reused every time.)
2. Update your resume normally and save it to the `$SourceDocx` /
   `$SourcePdf` locations (e.g. re-export from Word to Downloads).
3. Double-click `scripts/upload_resume.bat`.
   A terminal window opens, copies the files in, commits, and pushes —
   then waits for a keypress so you can read the result before it closes.

   (You can move `upload_resume.bat` anywhere convenient, like your Desktop,
   as long as `upload_resume.ps1` stays in the same `scripts/` folder next
   to it — the launcher looks for the script right beside itself.)

## Notes

- `.docx` / `.pdf` are binary files, so GitHub's diff view won't show you
  *what* changed inside them — only that the file changed, and when. If you
  want readable line-by-line diffs of your resume content, keep a plain-text
  or Markdown copy of the content alongside the binaries; ask if you'd like
  that added to these scripts.
- No passwords or tokens are stored in any of these files. Authentication is
  handled once by GitHub CLI (`gh auth login`) and remembered by Windows —
  these scripts are safe to share or back up as-is.
