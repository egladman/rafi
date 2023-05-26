# rafi

> RetroArch for Immutables

A minimalistic source-based package manager written in Bash. Ideal for immutable linux distributions, and single board computers alike.

- Does not require elevated privileges.
- External commands are used sparingly; builtins are used when possible.
- Respects the Freedesktop specification.

## Initalize

```
git clone https://github.com/egladman/rafi.git ~/rafi && ~/rafi/main init
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

1. Build builder docker image and start container with interactive session

```
./build.sh
./build.sh run
```

2. Run command(s) inside container. The source code is bind mounted into the working directory

```
./main help
```
