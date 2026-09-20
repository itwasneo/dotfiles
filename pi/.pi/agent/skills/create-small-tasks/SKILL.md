---
name: create-small-tasks
description: DON'T USE THIS SKILL UNLESS THE USER SPECIFICALLY CALLS /create-small-tasks. Use when the user asks to turn the latest assistant chat response into small, addressable, atomic task markdown files under the project root's ./tasks directory.
---

# Create Small Tasks

Convert the recommendations in the latest assistant chat response in the current conversation into small, independently addressable task files.

1. **Find the project root**
   - Work from the current repository/project root when obvious.
   - If inside a git repository, use `git rev-parse --show-toplevel` as the project root.
   - If the root is ambiguous, ask the user before creating files.

2. **Review the latest assistant response**
   - Use only the latest assistant-authored chat response as source material unless the user explicitly asks to include more context.
   - Extract concrete follow-up work, fixes, implementation steps, investigations, documentation tasks, tests, or cleanup items.
   - Do not invent tasks that are not grounded in that response.

3. **Split into atomic tasks**
   - Create one task per smallest independently actionable change.
   - Each task must be addressable without requiring unrelated tasks to be completed first.
   - Do not bundle unrelated changes.
   - If tasks have a dependency, keep them separate and note the dependency in the task file.
   - If the response contains no actionable tasks, say so and do not create files.

4. **Create files under `./tasks/`**
   - Create `<project-root>/tasks/` if it does not exist.
   - Inspect existing files in `./tasks/` and use the next ordered numeric identity.
   - Filename format: `NNN-short-kebab-title.md` (for example, `001-add-login-validation.md`).
   - Use three-digit IDs, continuing after the highest existing numeric prefix.
   - Avoid overwriting existing task files.

5. **Task markdown template**
   - Keep each task small and concise.
   - Use this exact template for every created task:

```markdown
---
id: <NNN>
title: <short task title>
status: open
created: <YYYY-MM-DD>
source: latest-assistant-response
---

# <short task title>

## Goal
<one concise paragraph describing the desired outcome>

## Scope
- <small concrete item in scope>

## Out of Scope
- <related but explicitly excluded work, or `None`>

## Steps
1. <small actionable step>
2. <small actionable step>

## Acceptance Criteria
- <observable condition that proves the task is done>

## Dependencies
- <task ID/title or `None`>
```

6. **Report**
   - After creating files, list each created path and one-line title.
   - If any potential task was skipped because it was too vague or not grounded in the latest assistant response, mention it briefly.
