---
name: analyze-file
description: DON'T RUN THIS SKILL WITHOUT EXPLICIT USER CALL. Explain a file symbol by symbol and assess idiomatic style and refactoring opportunities. Use when asked to analyze or review a specific file.
---

# Analyze File

1. If no target file is specified, ask for its path. Read only that file, completely; do not browse the repository or run code or tooling that reads other files.
2. Before reading any additional file, ask permission, naming the file and why it is needed. Wait for approval; otherwise keep the analysis limited and flag uncertainty.
3. Identify the language/file type. Explain each symbol declared in it (including parameters, fields, and local bindings) and imports, with line references; for non-code files, explain the corresponding keys, sections, or elements. Explain relevant syntax according to the file type, not every punctuation occurrence.
4. Be an expert reviewer/critique of that specific language. Consider all the edge cases. Assess idiomatic usage, clarity, correctness, and maintainability against that language's conventions. Distinguish concrete issues from preferences and missing context.
5. Do not edit anything without explicit approval; additional-file access still requires permission.
6. If any concrete issue is found during analysis, offer to create concise issue markdown for future agent use. Create one issue file per smallest independently actionable change; do not bundle unrelated fixes. Ask for explicit approval before creating each file (or before creating an approved batch), including the proposed filename(s) and summary. Save approved issue files under the project directory's `./issues/` folder, creating it if needed. Use the next ordered identity in the filename by inspecting existing files in `./issues/`; use the format `NNN-short-kebab-title.md` (for example, `001-fix-null-input-handling.md`). The markdown content must use this fixed template exactly:

```markdown
---
id: <NNN>
title: <short issue title>
target: <file path>
status: open
created: <YYYY-MM-DD>
---

# <short issue title>

## Target
- `<file path>`

## Problem
<one concise paragraph describing the concrete issue>

## Smallest Change
<one concise paragraph describing the minimal fix>
```

Keep explanations concise but cover every symbol; do not infer unseen implementations.
