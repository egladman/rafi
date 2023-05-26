# rafi

> RetroArch for Immutables

A dumb retroarch/libretro source-based installer written in Bash. Ideal for immutable linux distributions, and single board computers.

- Does not require elevated privileges
- External commands are used sparingly; builtins are used whenever possible.

## Initalize

```
git clone https://github.com/egladman/rafi.git ~/rafi && ~/rafi/main init
```

## Install Packages

A. Install group `retroarch`. The group includes all available retroarch packages.

```
rafi install @retroarch
```

B. Install packages `retroarch`, and `ppsspp`

```
rafi install retroarch ppsspp
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
