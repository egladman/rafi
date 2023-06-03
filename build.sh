#!/usr/bin/env bash

set -o errexit

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

    IMAGE_TAG=${IMAGE_TAG:-latest}
    IMAGE_REPOSITORY=${IMAGE_REPOSITORY:-retroarch-rafi}
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
	       ;;
	   #@ c,clean | Remove temporary files
	   c|clean)
	       rm -rf build
	       ;;
	   #@ i,image | Build image
	   i|image)
	       case "$2" in
		   ''|podman)
		       podman build --tag ${IMAGE_REGISTRY}${IMAGE_REPOSITORY}:${IMAGE_TAG} .
		       ;;
		   docker)
		       docker buildx build --file Containerfile --tag ${IMAGE_REGISTRY}${IMAGE_REPOSITORY}:${IMAGE_TAG} .
		       ;;
		   *)
		       log::fatal "Unsupported: $2"
		       ;;
	       esac
	       ;;
	   #@ r,run | Run image interactively
	   r|run)
	       case "$2" in
		   ''|podman)
		       podman run --volume "$(pwd):/src" --rm -it ${IMAGE_REGISTRY}${IMAGE_REPOSITORY}:${IMAGE_TAG} bash
		       ;;
		   docker)
		       docker run --volume "$(pwd):/src" --rm -it ${IMAGE_REGISTRY}${IMAGE_REPOSITORY}:${IMAGE_TAG} bash
		       ;;
		   *)
		       log::fatal "Unsupported: $2"
		       ;;
	       esac
	       ;;
	   #@ o,oci-bundle | Build oci compliant image
	   o|oci-bundle)
	       mkdir -p "build/${argv}" || true

	       case "$2" in
		   ''|podman)
		       podman build --tag ${IMAGE_REGISTRY}${IMAGE_REPOSITORY}:${IMAGE_TAG} .
		       podman save --format=oci-dir --output "build/${argv}" ${IMAGE_REGISTRY}${IMAGE_REPOSITORY}:${IMAGE_TAG}
		       ;;
		   docker)
		       docker buildx build --file Containerfile --output=type=oci,dest=- . | tar -C "build/${argv}" -xvf -
		       ;;
		   *)
		       log::fatal "Unsupported: $2"
		       ;;
	       esac

	       oci-runtime-tool generate --output "build/${argv}/config.json"
	       ;;
           *)
	       log::_fatal 128 "Invalid argument: '$argv'. Run $0 help" >&2
               ;;
        esac
	exit 0
    done
}

main "$@"
