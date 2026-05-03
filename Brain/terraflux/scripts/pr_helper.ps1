# pr_helper.ps1
param([string]\ = 'agent-suggestion/\20260503-1155')
git checkout -b \
git add vault/suggestions/*
git commit -m 'chore: agent suggestions'
Write-Host 'Create PR manually or use gh pr create after authentication.'
