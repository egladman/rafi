# rafi

> RetroArch for Immutables

A minimalistic source-based package manager written in Bash. Ideal for immutable linux distributions, and single board computers. Originally started as a RetroArch installer for the Steam Deck.

- Does not require elevated privileges.
- Supports installing multiple versions of a package.
- External commands are used sparingly; builtins are used whenever possible.
- Respects the Freedesktop specification.

## Why this over [asdf](https://github.com/asdf-vm/asdf)?

Some of my gripes:

- When auto-complete is enabled `asdf install <name><TAB>` makes network calls. This smells.
- Very loose packaging standards. Plugin quality varies immensely.
- Heavy reliance on external commands and pipes. This leads to a degraded user experience when waiting for commands/prompts to return.

## Setup

Clone to `~/rafi` and symlink the executable to `~/.local/bin/rafi`

```
git clone https://github.com/egladman/rafi.git ~/rafi && ~/rafi/main bootstrap install
```

### Bash

```
eval "$(rafi init bash)"
```

### Sh

todo

### Fish

todo

### Nushell

todo

## Install Packages

A. Install group `retroarch`. The group includes the retroarch package itself and all available libretro cores.

```
rafi install @retroarch
```

B. Install packages `retroarch`, and `libretro-ppsspp`

```
rafi install retroarch libretro-ppsspp
```

## Development

1. Build docker image and start container with interactive session

```
./dev.sh
./dev.sh run
```

2. Run command(s) inside container. The source code is bind mounted into the working directory

```
./main help
```
