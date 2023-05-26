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
    printf '%s\n' "$#"
}

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

fn::exists() {
    declare -F "${1:?}" > /dev/null
}
