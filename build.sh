#!/usr/bin/env bash

set -o errexit

docker::build() {
    docker build . --tag rafi-builder:latest
}

docker::run() {
    docker run --volume "$(pwd):/src" --rm -it rafi-builder:latest bash
}

spack::install() {
    spack --env . install
}

usage::print() {
    # Usage: usage::print file

    declare -a cmd
    cmd=("${0##*/}")
    if [[ "$0" != "$1" ]]; then
	cmd+=("${1##*/}")
    fi
    
    printf '\n%s: %s\n' "Usage" "${cmd[*]}"
    while read -r line; do
	tmp="$(string::trim "$line")"
	if [[ "$tmp" == "#@"* ]]; then
	   arr=($(string::split "${tmp###@ }" "|"))
	   printf '%s\n' "${arr[0]}"     # argument
	   printf '  %s\n' "${arr[*]:1}" # description
	fi
    done < "$0"
}

init() {
    for f in "lib/"*.sh; do
	source "$f"
    done
}

main() {
    init

    local argv
    while [[ $# -ge 0 ]]; do
        argv="$1"

        case "$argv" in
	   #@ h,help | Print this text
	   h|help|-h|--help)
	       usage::print
	       exit 0
	       ;;
	   #@ l,local | Run spack install locally [default]
	   ''|l|'local')
	       spack::install
	       exit 0
	       ;;
	   #@ i,img | Run spack install in docker. Creates a builder image
	   i|img|image)
	       docker::build
	       exit 0
	       ;;
	   #@ r,run | Run builder image interactively
	   r|run)
	       docker::run
	       exit 0
	       ;;
           *)
	       log::_fatal 128 "Invalid argument: '$argv'. Run $0 help" >&2
               ;;
        esac
    done
}

main "$@"
