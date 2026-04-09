# CLAUDE.md

## Project overview

tolmoenv is a shell-based version manager for the [Tolmo CLI](https://github.com/tolmohq/tolmo), distributed via Homebrew tap (`tolmohq/tolmoenv`) and manual git clone.

## Architecture

- `bin/tolmo` — shim that resolves and execs the active tolmo version
- `bin/tolmoenv` — CLI entrypoint, dispatches to subcommands in `libexec/`
- `libexec/tolmoenv-*` — individual subcommands (install, use, list, etc.)
- `lib/helpers.sh` — shared functions sourced by all scripts
- `libexec/tolmoenv-version` — contains the hardcoded version string (must be updated on each release)
- `Formula/tolmoenv.rb` — Homebrew formula

## Key constraints

- **Symlink resolution**: `bin/tolmo` and `bin/tolmoenv` must resolve symlinks before computing `TOLMOENV_ROOT`. Homebrew creates a chain of relative symlinks: `/opt/homebrew/bin/tolmoenv` → `../Cellar/tolmoenv/<ver>/bin/tolmoenv` → `../libexec/bin/tolmoenv`. Never use plain `dirname "$0"` — always resolve via the `while [ -L "$SELF" ]` loop that converts relative symlinks to absolute paths at each hop.
- **No namespace collisions**: The Homebrew formula installs everything under `libexec/` and only symlinks the two binaries. This avoids conflicts with other tools (e.g. tfenv's `lib/helpers.sh`). Never install `lib/` or `libexec/` directly into the Homebrew prefix.
- **TOLMOENV_ROOT**: Always derived from script location, never hardcoded to `$HOME/.tolmoenv`. This applies to ALL scripts: `bin/`, `lib/`, and `libexec/`. Users can override via the env var.
- **`set -e` safety**: Any `grep` that may have zero matches must use `|| true`. Any `[ -n "$var" ] && ...` at the end of a case branch needs a trailing `true` to avoid exit code 1.

## Homebrew install layout

When installed via Homebrew, files land at:
```
/opt/homebrew/Cellar/tolmoenv/<ver>/
├── bin/
│   ├── tolmo       → ../libexec/bin/tolmo       (symlink)
│   └── tolmoenv    → ../libexec/bin/tolmoenv     (symlink)
└── libexec/
    ├── bin/         (actual scripts)
    ├── lib/         (helpers.sh)
    └── libexec/     (subcommands)
```

## Homebrew release process

The formula lives in the same repo as the code. Brew fetches the formula from the default branch but downloads the archive from the tag. The tag always lags one commit behind the formula SHA update — this is expected.

When cutting a new release:
1. Update the version string in `libexec/tolmoenv-version` to match the new version
2. Finish all code changes, commit, and push to main
3. User creates GPG-signed tag and pushes it (never use `--no-gpg-sign` or skip signing)
4. Download the GitHub archive: `curl -fsSL -L -o /tmp/tolmoenv.tar.gz https://github.com/tolmohq/tolmoenv/archive/refs/tags/v<VERSION>.tar.gz`
5. Compute SHA256: `shasum -a 256 /tmp/tolmoenv.tar.gz`
6. Update `url` and `sha256` in `Formula/tolmoenv.rb` in a follow-up commit (do NOT move the tag to this commit)

## Development rules

- All scripts use `#!/usr/bin/env bash` and `set -euo pipefail`
- Keep scripts POSIX-friendly where possible (no bashisms beyond what's already used)
- Test changes with both `brew install` and manual git clone workflows

## Testing changes

Always test via the Homebrew-installed path before declaring a fix works:
```bash
# Copy changed files into the Cellar
cp bin/tolmo bin/tolmoenv /opt/homebrew/Cellar/tolmoenv/<ver>/libexec/bin/
cp libexec/tolmoenv-* /opt/homebrew/Cellar/tolmoenv/<ver>/libexec/libexec/
cp lib/helpers.sh /opt/homebrew/Cellar/tolmoenv/<ver>/libexec/lib/

# Run and verify
/opt/homebrew/bin/tolmoenv <command>
```
Never report a fix without running the command and seeing the expected output.
