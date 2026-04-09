# tolmoenv

Version manager for the [Tolmo CLI](https://github.com/tolmohq/tolmo). Inspired by [tfenv](https://github.com/tfutils/tfenv) and [dctlenv](https://github.com/wbeuil/dctlenv).

## Installation

### Homebrew (macOS)

```bash
brew tap tolmohq/tolmoenv https://github.com/tolmohq/tolmoenv
brew install tolmoenv
```

### Manual

```bash
git clone https://github.com/tolmohq/tolmoenv.git ~/.tolmoenv
echo 'export PATH="$HOME/.tolmoenv/bin:$PATH"' >> ~/.bashrc  # or ~/.zshrc
```

Restart your shell or run `source ~/.bashrc`.

## Usage

```bash
# Install a specific version
tolmoenv install 0.3.0

# Install latest stable
tolmoenv install latest

# Install latest nightly
tolmoenv install latest:nightly

# Switch active version
tolmoenv use 0.3.0

# List installed versions
tolmoenv list

# List available versions (stable + nightly)
tolmoenv list-remote

# List only stable versions
tolmoenv list-remote --stable

# List only nightly versions
tolmoenv list-remote --nightly

# Uninstall a version
tolmoenv uninstall 0.3.0
```

## Per-project version

Create a `.tolmo-version` file in your project root:

```bash
echo "0.3.0" > .tolmo-version
```

When you run `tolmo` from that directory, tolmoenv will automatically use the specified version.

## How it works

tolmoenv downloads tolmo binaries from [GitHub releases](https://github.com/tolmohq/tolmo/releases) and stores them under `~/.tolmoenv/versions/`. The `tolmo` shim in `~/.tolmoenv/bin/` resolves the active version (from `.tolmo-version` or `~/.tolmoenv/version`) and executes the correct binary.

SHA256 checksums are verified on every install.

## Environment variables

| Variable | Description |
|----------|-------------|
| `TOLMOENV_ROOT` | Override the installation directory (default: `~/.tolmoenv`) |
| `TOLMOENV_ARCH` | Override architecture detection (e.g. `arm64`) |
| `TOLMOENV_DEBUG` | Set to `1` for verbose output |
