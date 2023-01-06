#!/bin/bash
# creates and updates the app
date '+keyreg-teal-test start %Y%m%d_%H%M%S'

set -e
set -x
set -o pipefail
export SHELLOPTS

WALLET=$1


# Directory of this bash program
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


gcmd="/Users/power/node/goal -d /Users/power/node/data -w simplewebapp"


# Get one account from each node
ACCOUNT='67ODCFJLIKQHKTF6KXNKJGRXNWDPGJS4XTV2IMRL5UFCKAMAPWFG2F22GU'
${gcmd} app read --app-id 24450735 --guess-format --local --from $ACCOUNT
ACCOUNT2='Z6S4GMC54UO4SPNX3E4KKBBYCFD7PARGAUVHL5VLQ32EQCPPJPIZAO2BM4'
${gcmd} app read --app-id 24450735 --guess-format --local --from $ACCOUNT2