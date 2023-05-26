#!/usr/bin/env bash

set -o errexit

source /spack/share/spack/setup-env.sh

export CC="$(spack location -i gcc)/bin/gcc"
export CXX="$(spack location -i gcc)/bin/g++"

exec "$@"
