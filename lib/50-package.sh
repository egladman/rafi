package::find_by_name() {
    local name="${1:?}"

    for d in "${SELF_DIR:?}"/pkgs/**/"${name}"; do
	# FIXME: This assumes there are no package name conflicts
	package="$d"
	break
    done

    if [[ -z "$package" ]]; then
	log::fatal "Could not find path associated with package: $name"
    fi
    
    printf '%s' "$package"
}
