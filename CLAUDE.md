# CLAUDE.md

## Project overview

tolmoenv is a shell-based version manager for the [Tolmo CLI](https://github.com/tolmohq/tolmo), distributed via Homebrew tap (`tolmohq/tolmoenv`) and manual git clone.

## Architecture

- `bin/tolmo` — shim that resolves and execs the active tolmo version
- `bin/tolmoenv` — CLI entrypoint, dispatches to subcommands in `libexec/`
- `libexec/tolmoenv-*` — individual subcommands (install, use, list, etc.)
- `lib/helpers.sh` — shared functions sourced by all scripts
- `Formula/tolmoenv.rb` — Homebrew formula

## Key constraints

- **Symlink resolution**: `bin/tolmo` and `bin/tolmoenv` must resolve symlinks before computing `TOLMOENV_ROOT`. Homebrew symlinks binaries from `libexec/bin/` into `/opt/homebrew/bin/`. Never use plain `dirname "$0"` — always resolve via the `while [ -L "$SELF" ]` loop first.
- **No namespace collisions**: The Homebrew formula installs everything under `libexec/` and only symlinks the two binaries. This avoids conflicts with other tools (e.g. tfenv's `lib/helpers.sh`). Never install `lib/` or `libexec/` directly into the Homebrew prefix.
- **TOLMOENV_ROOT**: Always derived from script location, never hardcoded to `$HOME/.tolmoenv`. Users can override via the env var.

## Homebrew release process

The formula lives in the same repo as the code. Brew fetches the formula from the default branch but downloads the archive from the tag. The tag always lags one commit behind the formula SHA update — this is expected.

When cutting a new release:
1. Finish all code changes and push to main
2. Tag the commit (user handles GPG-signed tags) and push the tag
3. Download the GitHub archive: `curl -fsSL -L -o /tmp/tolmoenv.tar.gz https://github.com/tolmohq/tolmoenv/archive/refs/tags/v<VERSION>.tar.gz`
4. Compute SHA256: `shasum -a 256 /tmp/tolmoenv.tar.gz`
5. Update `url` and `sha256` in `Formula/tolmoenv.rb` in a follow-up commit (do NOT move the tag to this commit)

## Development rules

- All scripts use `#!/usr/bin/env bash` and `set -euo pipefail`
- Keep scripts POSIX-friendly where possible (no bashisms beyond what's already used)
- Test changes with both `brew install` and manual git clone workflows
- The user signs git tags with GPG — never use `--no-gpg-sign` or skip signing
