#!/bin/bash
function check_tcp4port_listen() {
    ss -lt4 | grep ":$1" &>/dev/null
}
function _add_port() {
    local PORT=$2
    local JOBS=$3
    if check_tcp4port_listen "${PORT}"; then
        echo $1" 127.0.0.1:${PORT}/${JOBS},lzo"
        return 0
    else
        echo $1
        return 1
    fi
}
function _cc_jobs() {
    if check_tcp4port_listen 16670; then
        echo 12
    else
        echo 0
    fi
}
function _cc_host() {
    _add_port "$1" 16670 "12"
}
function _internal_jobs() {
    local per_machine=16
    local JOBS=0
    if check_tcp4port_listen 16666; then
        JOBS=$((${JOBS} + ${per_machine}))
    fi
    if check_tcp4port_listen 16667; then
        JOBS=$((${JOBS} + ${per_machine}))
    fi
    if check_tcp4port_listen 16668; then
        JOBS=$((${JOBS} + ${per_machine}))
    fi
    echo ${JOBS}
}
function _internal_hosts() {
    local per_machine=24
    local HOSTS="$1"
    HOSTS=$(_add_port "${HOSTS}" 16666 "${per_machine}")
    HOSTS=$(_add_port "${HOSTS}" 16667 "${per_machine}")
    HOSTS=$(_add_port "${HOSTS}" 16668 "${per_machine}")
    echo ${HOSTS}
}
function assemble_distcc_hosts() {
    local DISTCC_HOSTS="localhost/2"
    if [[ $(_internal_jobs) -gt 0 ]]; then
        DISTCC_HOSTS=$(_internal_hosts "${DISTCC_HOSTS}")
    fi
    if [[ $(_cc_jobs) -gt 0 ]]; then
        DISTCC_HOSTS=$(_cc_host "${DISTCC_HOSTS}")
    fi
    if [[ "${DISTCC_HOSTS}" == "localhost/2" ]]; then
        # No remote hosts found, default to full local.
        DISTCC_HOSTS="localhost/$(nproc)"
    fi
    echo ${DISTCC_HOSTS}
}
function get_total_distcc_jobs() {
    local TOTAL_JOBS=$(nproc);
    TOTAL_JOBS=$((${TOTAL_JOBS} + $(_internal_jobs)))
    TOTAL_JOBS=$((${TOTAL_JOBS} + $(_cc_jobs)))
    echo ${TOTAL_JOBS}
}
function run_distcc() {
  DISTCC_HOSTS=$(assemble_distcc_hosts)
  echo ${DISTCC_HOSTS}
  DISTCC_HOSTS=$(assemble_distcc_hosts) \
    CCACHE_PREFIX="distcc" \
    "$@"
}
function distcc_build() {
    run_distcc "$@" -j $(get_total_distcc_jobs)
}
alias db=distcc_build
