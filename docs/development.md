# Development

## Branching

- `main`: stable releases.
- `develop/v2`: integration branch for v2.
- Feature branches: isolated development when useful.

## Commit convention

Use Conventional Commits:

- `feat(scope): ...`
- `fix(scope): ...`
- `refactor(scope): ...`
- `style(scope): ...`
- `docs: ...`
- `chore: ...`

## Quality checks

Validate shell scripts with `bash -n`.
Use ShellCheck and application-specific validators where applicable.
