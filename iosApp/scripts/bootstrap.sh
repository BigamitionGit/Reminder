#!/bin/bash

set -eu

PROJECT_DIR=$(cd $(dirname $0)/..; pwd)
cd $PROJECT_DIR

# bootstrap
scripts/generate-strings.sh
scripts/generate-sharedKit.sh

echo ""
echo "********************************************************"
echo " This ios project has set up."
echo "********************************************************"
echo ""
