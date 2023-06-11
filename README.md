# rafi

A minimalistic source-based package manager written in Bash. Ideal for immutable linux distributions, and single board computers. Originally started as a RetroArch installer for the Steam Deck.

- Does not require elevated privileges.
- Supports installing multiple versions of a package.
- External commands are used sparingly; builtins are used whenever possible.
- Respects the Freedesktop specification.

## Why this over [asdf](https://github.com/asdf-vm/asdf)?

Some of my gripes with asdf:

- When auto-complete is enabled `asdf install <name><TAB>` makes network calls. It's ofthen a laggy mess.
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

## Install Packages

A. Install group:

```
rafi install @<group_name>
```

B. Install package(s):

```
rafi install <package_name> <package_name>
```

## Development

1. Build docker image and start container with interactive session

```
./build.sh
./build.sh run
```

2. Run command(s) inside container. The source code is bind mounted into the working directory

```
./main help
```
