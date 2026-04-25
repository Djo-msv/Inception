#!/bin/bash

# enables strict error handling in Bash scripts
set -eo pipefail
shopt -s nullglob


# check to see if this file is being run or sourced from another script
_is_sourced() {
	# https://unix.stackexchange.com/a/215279
	[ "${#FUNCNAME[@]}" -ge 2 ] \
		&& [ "${FUNCNAME[0]}" = '_is_sourced' ] \
		&& [ "${FUNCNAME[1]}" = 'source' ]
}

_main() {
	if [ "${1:0:1}" = '-' ]; then
		set -- mariadbd "$@"
	fi

	# need to setup database
	
	#exec "$@"
}

if ! _is_sourced; then
	_main "$@"
fi


