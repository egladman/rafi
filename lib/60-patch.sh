patch::apply() {
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
	patch --strip 0 --input "$p"
    done
}
