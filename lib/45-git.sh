git::checkout() {
    local rc=0
    git checkout "${1:?}" || rc=$?

    local regex="^(0|([1-9])+)*"
    if [[ $rc -gt 0 ]] && [[ "$1" =~ $regex ]]; then
	log::warn "Checkout attempt failed with reference '${1}'. Trying 'v${1}'."
	git checkout "v${1}"
    fi
}

git::patch() {
    declare -a wrkarr
    if [[ -d ../pkg/patches ]]; then
	wrkarr=(../pkg/patches/*.patch)
	set -- "${wrkarr[@]}"
    fi

    if [[ -z "$1" ]]; then
	log::fatal "No patches found."
    fi
    
    for p in "$@"; do
	log::debug "Applying patch: $p"
	git apply --stat --apply "$p"
    done
}

git::clone() {
    git clone "${1:?}" .
}

git::rclone() {
    git clone --recurse-submodules "${1:?}" .
}

git::pull() {
    git pull origin "${1:?}"
}
