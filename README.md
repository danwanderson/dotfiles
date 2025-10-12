# dotfiles

Various dotfiles and setup scripts for configuring my *nix shell environments.

## Setup

To set up your environment, run the `setup.sh` script:

```sh
./setup.sh [options]
```

### Options

- `-h, --help`                   Show help message and exit
- `-l, --link`                   Link dotfiles (creates symlinks in home directory)
- `-a, --all`                    Run all setup steps (requirements, vim, zsh, link)
- `-r, --install-requirements`   Install required packages (fzf, fd, zsh, git, vim)
- `-v, --setup-vim`              Setup vim and plugins
- `-z, --setup--zsh`             Setup zsh and plugins
- `--debug`                      Enable debug mode
- `--dryrun`, `--dry-run`        Show what would be done, but do not actually do it

You can combine options as needed. For example, to only set up vim and link dotfiles:

```sh
./setup.sh -v -l
```

## What it does

- Installs required tools (fzf, fd, zsh, git, vim) if requested
- Sets up Vim with Vundle and plugins
- Sets up Zsh with Oh My Zsh and plugins
- Links dotfiles to your home directory

Supports Debian-based systems and macOS.
