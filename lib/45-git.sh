git::checkout() {
    local rc=0
    git checkout "${1:?}" || rc=$?

    local regex="^(0|([1-9])+)*"
    if [[ $rc -gt 0 ]] && [[ "$1" =~ $regex ]]; then
	log::warn "Checkout attempt failed with reference '${1}'. Trying 'v${1}'."
	git checkout "v${1}"
    fi
}
