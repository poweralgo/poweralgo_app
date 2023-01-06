#!/bin/bash

date '+keyreg-teal-test start %Y%m%d_%H%M%S'

set -e
set -x
set -o pipefail
export SHELLOPTS

WALLET=$1


# Directory of this bash program
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

gcmd="/Users/power/node/goal -d /Users/power/node/data -w simplewebapp"

ACCOUNT="67ODCFJLIKQHKTF6KXNKJGRXNWDPGJS4XTV2IMRL5UFCKAMAPWFG2F22GU"
UPDATE=$(${gcmd} app update --app-id=24450735 --from ${ACCOUNT}  --approval-prog ./dex.teal   --clear-prog ./dex_clear.teal )




