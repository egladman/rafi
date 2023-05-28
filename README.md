# rafi

> RetroArch for Immutables

A minimalistic source-based package manager written in Bash. Ideal for immutable linux distributions, and single board computers. Originally written for the Steam Deck.

- Does not require elevated privileges.
- Supports installing multiple versions of a package.
- Performant. External commands are used sparingly; builtins are used whenever possible.
- Respects the Freedesktop specification.

## Setup

Clone to `~/rafi` and symlink the executable to `~/.local/bin/rafi`

```
git clone https://github.com/egladman/rafi.git ~/rafi && ~/rafi/main bootstrap install
```

### Bash

```
eval "$(rafi init bash)"
```

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
