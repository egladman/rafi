log::_println() {
    # Usage: log::_println "prefix" "string"
    printf -v now '%(%m-%d-%Y %H:%M:%S)T' -1
    printf '%b\n' "[${1:: 4}] ${now} ${0##*/}: ${2:?}"
}

log::_fatal() {
    # Usage: log::_fatal code "string"
    log::_println "FATAL" "${2:?}"
    exit ${1:?}
}

log::info() {
    # Usage: log::info "string"
    log::_println "INFO" "${1:?}"
}

log::debug() {
    # Usage: log::debug "string"
    if [[ -z "$DEBUG" ]] || [[ $DEBUG -eq 0 ]]; then
	return 0
    fi
    log::_println "DEBUG" "${1:?}"
}

log::warn() {
    # Usage: log::warn "string"
    log::_println "WARN" "${1:?}"
}

log::error() {
    # Usage: log::error "string"
    log::_println "ERROR" "${1:?}" >&2
}

log::fatal() {
    # Usage: log::fatal "string"
    log::_fatal 125 "${1:?}" >&2
}
