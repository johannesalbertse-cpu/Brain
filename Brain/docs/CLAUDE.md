# CLAUDE Vault Rules (TerraFlux Brain)

Scope
- Read: vault/content
- Write: vault/suggestions only

Hard rules
- Never output or store secrets, credentials, or PII.
- Do not modify files outside vault/suggestions.
- Suggestions must include frontmatter: agent_suggestion: true; confidence: 0.0-1.0; rationale: string

Suggestion workflow
1. Agent writes a file to vault/suggestions/.
2. Automation creates a PR from suggestions/ to infra/agent-suggestions branch.
3. Human Approver reviews, runs CI checks, and merges to vault/content/ when approved.
