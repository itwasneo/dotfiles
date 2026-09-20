---
name: resolve-task
description: DON'T USE THIS SKILL UNLESS THE USER SPECIFICALLY CALLS /resolve-task. Resolve a numbered task from the current project's tasks directory using tests first, explicit user approval, then implementation. Only use when the user explicitly invokes resolve-task with a task ID.
disable-model-invocation: true
---

# Resolve Task

Usage: `/skill:resolve-task <task-id>` (for example, `/skill:resolve-task 001`).
Accept a numeric task ID, not an arbitrary path. Work on one task at a time.

## 1. Resolve and inspect

1. Require exactly one numeric task ID. If missing or invalid, ask for it and stop.
2. Find the project root with `git rev-parse --show-toplevel`; otherwise use the
   obvious project root or ask if ambiguous. Task paths are relative to this root,
   not to the skill directory.
3. Find the matching `tasks/NNN-*.md`, accepting equivalent IDs such as `1` and
   `001`. Confirm any frontmatter ID agrees with the filename. If there are no
   matches, conflicting IDs, or multiple matches, report that and ask; do not guess
   or create a replacement task.
4. Read the complete task, applicable repository instructions, referenced design
   documents, and relevant existing code/tests. Follow existing project structure
   and repository rules. If they conflict with this skill's branch workflow, ask
   before proceeding.
5. Inspect the working tree. Preserve unrelated user changes. If task-related files
   already contain changes that prevent a clean review boundary, ask how to proceed.
6. Summarize the task and map acceptance criteria to tests. Ask about ambiguous
   requirements rather than silently expanding scope. If the task is already done,
   report that instead of restarting it.

## 2. Feature branch setup

Complete this before changing any task files, tests, scaffolding, or implementation.

1. Require a Git repository and a clean working tree, including the index and
   untracked files. If dirty, ask the user how to preserve the changes; never
   automatically stash, discard, stage, or commit unrelated work.
2. Use `main` as the integration branch. If the repository instead uses `master`
   or another name, ask the user which branch to use; do not rename or substitute
   branches silently.
3. Determine the authoritative remote from main's tracking configuration. If
   ambiguous, ask. Fetch it, switch to main, and update with a fast-forward-only
   merge from its remote-tracking branch. Do not use reset, force-push, or an
   automatic rebase. If histories diverge or local main contains unpublished
   commits, explain and ask how to proceed. If fetching fails, do not claim the
   base is current. With no remote, use the latest local main and disclose that.
4. Create `feature/task-<NNN>-<short-title>` from the resulting main tip and record
   the base commit. Follow an explicit repository naming convention if present.
   If the branch already exists, ask whether to resume it; never overwrite it.
5. Keep all setup, test, implementation, and task-status changes on this feature
   branch. Do not implement directly on main. If resuming a session, verify the
   current branch and prior approval state before changing files.

## Git diff visibility

For newly created task-related files, use `git add --intent-to-add -- <paths>`
(`git add -N`) so their contents appear in ordinary `git diff`. This is permitted
during setup, tests-only, and implementation-only phases; it does not authorize
mixing phase contents or creating commits.

Use explicit file paths and include only files created for the current task.
Never add unrelated user files, secrets, or generated build artifacts. Intent-to-add
records paths without staging their contents; leave changes available for review.
Use normal staging only at the approved commit checkpoints described below.

## 3. Tests-only phase

- Write unit tests for the acceptance criteria, including relevant negative and
  boundary cases. Use isolated integration tests where acceptance inherently
  requires a real database or external boundary; explain why.
- Modify only test files and test-only fixtures. Do not change production code,
  migrations, schemas, dependencies, or implementation stubs to make tests compile.
- Never weaken assertions, ignore tests, or suppress warnings to manufacture success.
- If test discovery requires module wiring, dependencies, or scaffolding outside
  test files, propose the exact setup changes and wait for approval. Perform them
  in a separate setup-only phase, without editing tests or implementing behavior.
  Then return to the tests-only phase.
- Run the repository's required validation commands. Report missing implementation
  compilation errors or failing tests honestly; they are expected at this stage.
  Do not claim undiscovered tests passed. If executing a command would cause
  unauthorized side effects, explain the limitation and ask before proceeding.
- Inspect the phase diff to ensure implementation files were not modified.

### Mandatory approval gate

Present:
1. Test files changed and acceptance criteria covered.
2. Validation results, including failures and discovery/setup limitations.
3. Any proposed public API assumptions exposed by the tests.

Then explicitly ask the user to approve the tests and **stop the response**.
Do not begin implementation in the same response. The original task request,
silence, or a request to revise tests is not approval. Approval applies only to
this task and the exact reviewed test contents.

## 4. Commit the approved tests

After explicit test approval and before any implementation changes:

1. Verify the reviewed tests are unchanged and the feature branch is active.
2. Run required validation and dependency audits; review and report findings.
   Compilation/test failures caused solely by missing implementation are expected
   for this tests-first checkpoint and must be disclosed. Do not fix them with
   implementation code, suppress warnings, or bypass commit hooks. If repository
   rules prohibit committing this expected failing state, stop and ask.
3. Stage only the approved tests, fixtures, and any separately approved task setup
   changes not already committed. Exclude implementation and unrelated changes.
4. Create a dedicated feature-branch commit and report its hash and validation
   state. Record the approved test paths and checksums against this checkpoint.
5. Begin implementation only after the commit succeeds. If the exact approved
   checkpoint was already committed, verify and reuse it rather than creating an
   empty commit. Keep the checkpoint separate from implementation commits.

Repeat this checkpoint step after any revised tests receive renewed approval,
committing only the revised tests and approved setup—not pending implementation.

## 5. Implementation-only phase

- Resume only after explicit user approval of the tests. If approval cannot be
  established from the conversation, or the reviewed tests have since changed,
  ask again rather than assuming approval.
- Verify the approved test checkpoint commit exists and matches the reviewed
  contents/checksums before implementation.
- Implement only the task's agreed behavior, leaving approved test files and
  fixtures unchanged. Production changes, migrations, and needed dependency
  changes belong here, subject to repository rules.
- Never modify implementation and test files in the same phase. Separate tool
  calls alone do not establish separate phases.
- If a test is incorrect or incomplete, stop implementation, explain the issue,
  and ask to return to a tests-only revision phase. Obtain approval of revised
  tests before resuming implementation. Do not silently fix tests while coding.
- Run all required validation and regression checks. Follow dependency-audit rules
  whenever adding dependencies and before any requested commit. Review and report
  vulnerabilities or warnings before proceeding; do not suppress compiler warnings.
- Verify approved tests remain unchanged and that they were actually discovered
  and executed. Report regressions, failures, and remaining gaps honestly.

## 6. Review implementation before committing

- Leave implementation contents uncommitted and unstaged for user review; use
  intent-to-add for new task files so ordinary `git diff` includes them. Passing
  tests, test approval, or a request to continue does NOT authorize an implementation
  commit. The approved-tests checkpoint in section 4 is the sole automatic commit
  exception; it must never include implementation changes.
- Present changed implementation paths, the diff summary, acceptance results,
  regression results, and audit findings. Verify approved tests remain unchanged.
- Ask: **May I commit this implementation?** Then stop and wait for explicit
  approval. Do not mark the task done before implementation approval.
- Approval applies to the reviewed implementation only. If substantive changes
  follow review, obtain renewed approval before committing them.

### Commit after implementation approval

- Once approved, mark the task done using its existing status convention only if
  acceptance criteria and required validation pass. Include that metadata change
  in the approved task commit; avoid unrelated documentation.
- Run required dependency audits before the commit and review/report findings.
  Do not bypass warnings, failed checks, or hooks. Stage only approved task changes.
- Create the implementation commit on the feature branch and report its hash.
- Refresh remote state and inspect whether main advanced. If integration is needed,
  explain it and ask approval before merging main into the feature branch; this
  skill does not authorize automatic integration commits. Never rewrite history
  or silently resolve conflicts. Changes to tests require renewed test approval.
- After approved integration, rerun validation and verify the approved tests.
  Any resulting implementation/conflict-resolution commit requires explicit
  approval and the usual pre-commit audit.

### Mandatory merge approval gate

Present the feature branch name and exact commit, target main commit, summary of
changes, acceptance results, regression results, and audit findings. Then ask:

> May I merge this feature branch into main?

**Stop and wait for explicit approval.** Test approval, implementation approval,
and permission to commit are not merge approval. Task completion and successful
validation do not authorize merging. Approval is
specific to the reviewed feature and main tips; if either changes, revalidate and
request approval again. If approval is declined, leave the feature branch intact.

## 7. Merge after approval

1. Verify the working tree is clean and the branch tips match the reviewed commits.
   Refresh remote state; if main has advanced, return to integration, validation,
   and the merge approval gate.
2. Switch to main and merge the approved feature branch. Prefer `--ff-only` when
   repository rules permit; if a merge commit is required, run audits before that
   commit and follow repository rules. Do not force changes or silently resolve
   conflicts. Do not use a squash/rebase that changes the reviewed history unless
   explicitly agreed.
3. Run required validation on the merged main tree and report the resulting commit.
   If post-merge validation fails, report it immediately; do not push, rewrite
   history, or automatically revert without asking.
4. Do not push, delete the feature branch, or begin another task unless requested.
   Merge approval alone does not authorize those additional actions.

This workflow uses conversational approval, not an automated enforcement mechanism.
No phase may bypass project-specific security or validation requirements.
