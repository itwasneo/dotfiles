---
name: fix-issue
description: DON'T USE THIS SKILL UNLESS THE USER SPECIFICALLY CALLS /fix-issue. Use when the user asks to fix a numbered issue from the repo's ./issues directory. Find the issue, follow repo branching rules, implement the fix, run tests, and report regressions.
---

# Fix Issue

Use only when the user provides an issue number (for example `7`, `007`, or `#7`). If missing, ask for it.

1. **Find the issue**
   - Work from the git repo root.
   - Find exactly one matching file in `./issues/` by numeric filename prefix or frontmatter `id`.
   - If none or multiple match, report/ask before continuing.
   - Read the issue completely.

2. **Prepare branch**
   - Check `git status --short`; stop if user changes are present.
   - Read repo docs for branching rules (`AGENTS.md`, `README.md`, `.github/`, etc.) and follow them.
   - If no rule exists, use `issue/<NNN>-<short-kebab-title>`.
   - Do not overwrite, reset, rebase, or delete user work.

3. **Implement**
   - Inspect only files needed for the issue.
   - Make the smallest focused change; avoid unrelated refactors.
   - Add tests only when appropriate.

4. **Test**
   - Determine the relevant unit test command from project docs/config.
   - Run a baseline before edits when practical.
   - Run tests after edits and compare with the baseline.
   - If a previously passing existing test now fails, stop and report:
     - command and test name,
     - why it failed,
     - whether the fix or the test expectation is wrong,
     - recommended fix.
   - Do not silently update test expectations just to pass.

5. **Report**
   - Summarize issue, branch, files changed, tests run, and result.
   - State blockers or unrun tests clearly.
   - Do not commit unless asked.

6. Commit and Merge
    - If user approves, fix the issue status, commit and merge the feature branch to the main.
