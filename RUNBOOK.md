## Incident: PowerShell action resolution 2026-05-04
- **Run-id:** 25316476321
- **Head SHA:** e2b9c0c71f965d02a9f4bfb81e99ee48aa7d182c
- **Final error line:** Unable to resolve action powershell/powershell@v1, unable to find version 1
- **Action taken:** Replaced powershell/powershell@v1 with actions/setup-powershell@v2; created .bak snapshot; opened PR and merged.
- **Verification:** Validator returned no unsupported uses patterns; latest run shows no ##[error] lines.
- **Follow-up:** Keep .bak until two successful runs; pin third-party actions; add pre-merge validation for uses lines.
