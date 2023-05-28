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

package::find_install() {
    local name="${1:?}"
    local version="$2"

    local pfx_dir="${SELF_DATA_DIR:?}/install/${name}/pfx"

    local count=$(fs::count "${pfx_dir:?}/"*)
    if [[ $count -eq 0 ]]; then
	log::error "Could not find install path for '$name'."
	return 0
    fi

    if [[ $count -gt 1 ]] && [[ -z "$version" ]]; then
	log::fatal "There is more than one version installed. Must specify the version."
    fi

    for d in "${pfx_dir}/"*; do
	printf '%s\n' "$d"
	break
    done
}
