string::trim() {
    # Usage: string::trim "   example   string    "
    : "${1#"${1%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

string::split() {
   # Usage: string::split "string" "delimiter"
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}

fn::exists() {
    declare -F "${1:?}" > /dev/null
}

fs::dir_name() {
    # Usage: fs::dirname "path"
    local tmp=${1:-.}

    [[ $tmp != *[!/]* ]] && {
        printf '/\n'
        return
    }

    tmp=${tmp%%"${tmp##*[!/]}"}

    [[ $tmp != */* ]] && {
        printf '.\n'
        return
    }

    tmp=${tmp%/*}
    tmp=${tmp%%"${tmp##*[!/]}"}

    printf '%s\n' "${tmp:-/}"
}

fs::mkdir() {
    # Usage: fs::mkdir dir...
    for p in "$@"; do
	if [[ -d "$p" ]]; then
	    continue
	fi

	log::debug "Creating directory: ${p}"
	mkdir -p "$p"
    done
}

fs::count() {
    # Usage: fs::count /path/to/dir/*

    local count=0
    for f in "$@"; do
	# Ignore '_', it has a special meaning to us
	if [[ "${f##*/}" == "_" ]]; then
	    continue
	fi
	count=$((count+1))
    done

    printf '%s\n' "$count"
}

fs::walk_dir() {
    # Usage: fs::walk_dirs "path/to/dir" func_name
    local path="${1:?}"
    local hook="${2:?}"
    
    for f in "${path}"/*; do
	if [[ -d "$f" ]]; then
	    "${FUNCNAME[0]}" "$f" "$hook"
	    continue
	fi

	"$hook" "$f"
    done
}

fs::walk_dir_reverse() {
    # Usage: fs::walk_dirs_reverse "path/to/dir" "path/to/dir" func_name
    #        fs::walk_dirs_reverse "path/to/dir" / func_name
    local path="${1:?}"
    local last_path="${2:?}"
    local hook="${3:?}"
 
    local dir_name
    dir_name="$(fs::dir_name "$path")"

    if [[ "$path" == "$last_path" ]] && [[ "$path" == "/" ]]; then
       	path=""
    fi
    
    for f in "${path}"/*; do
	if [[ ! -d "$f" ]]; then
	    "$hook" "$f"
	fi
    done
    
    if [[ -z "$path" ]] || [[ "$path" == "$last_path" ]]; then
	return 0
    fi

    "${FUNCNAME[0]}" "$dir_name" "$last_path" "$hook"
}

# TODO rename
path::basename() {
    # Usage: path::basename "path" ["suffix"]
    local tmp

    tmp=${1%"${1##*[!/]}"}
    tmp=${tmp##*/}
    tmp=${tmp%"${2/"$tmp"}"}

    printf '%s\n' "${tmp:-/}"
}

cmd::run() {
    if [[ $DRYRUN -eq 1 ]]; then
	set -- echo "$@"
    fi

    "$@"
}

version::first_stable() {
    # Usage: version::first_stable
    # Returns the first non prelease version
    local regex="^v?(0|([1-9])+)\.(0|([1-9])+)\.(0|([1-9]))"
    for v in "$@"; do
	if [[ "$v" =~ $regex ]] && [[ "$v" != "${BASH_REMATCH[-1]}-"* ]]; then
	    printf '%s\n' "$v"
	    return 0
	fi
    done

    return 1
}
