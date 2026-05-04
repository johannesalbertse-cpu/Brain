# agent-create-pr.ps1
Param(
  [string]$branch = $(Read-Host 'Branch name (e.g. feature/brief-description)'),
  [string]$title = $(Read-Host 'PR title'),
  [string]$body  = $(Read-Host 'PR body (short)')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Ensure clean working tree
if ((git status --porcelain) -ne '') {
  Write-Error 'Working tree not clean. Commit or stash changes first.'; exit 1
}

# Create branch from main
git fetch origin main
git checkout -b $branch origin/main

# Stage and commit (assumes Brain already wrote files to disk)
git add -A
git commit -m $title

# Push branch
git push -u origin $branch

# Open PR (requires gh CLI)
gh pr create --title $title --body $body --base main --head $branch

# Post a short comment with the Brain's plan summary (optional)
$prnum = gh pr view --json number --jq '.number'
$comment = "Super Copilot Brain created this PR. Johann review required. Plan summary: $body"
gh pr comment $prnum --body $comment

# Print the PR URL as the final line
$prurl = gh pr view --json url --jq '.url'
Write-Output $prurl
