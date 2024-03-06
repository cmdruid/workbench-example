#!/usr/bin/env bash
## Entrypoint Script

set -E

###############################################################################
# Environment
###############################################################################

###############################################################################
# Methods
###############################################################################

init() {
  ## Execute startup scripts.
  for script in `find "/scripts" -name *.sh | sort`; do
    echo "Running $script ..."
    $script 2>&1 | while IFS= read -r line; do echo " | ${line}"; done
    state="$?"
    [ $state -ne 0 ] && exit $state
  done
}

###############################################################################
# Main
###############################################################################

echo "Starting entryopoint script ..."

## Initialize startup scripts.
init

## Start bash terminal.
bash
