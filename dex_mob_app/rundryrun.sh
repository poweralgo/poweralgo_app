#!/bin/bash

date '+keyreg-teal-test start %Y%m%d_%H%M%S'

set -e
set -x
set -o pipefail
export SHELLOPTS

WALLET=$1


# Directory of this bash program
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

gcmd="/Users/power/node/goal -d /Users/powers/node/data -w simplewebapp"

${gcmd} clerk dryrun -t ./upload/dryrun.dr --dryrun-dump  -o dr.msgp

