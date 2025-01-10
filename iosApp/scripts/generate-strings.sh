#!/bin/bash -x

set -eu

PROJECT_DIR=${PROJECT_DIR:-$(cd $(dirname $0)/..; pwd)}
cd $PROJECT_DIR
pwd

# convert strings.xml to Localizable.xcstrings
echo "↔️  Converting strings.xml to Localizable.xcstrings..."
scripts/generate-strings.rb \
  ../features/reminder/src/androidMain/res/values-ja/strings.xml \
  ../features/reminder/src/androidMain/res/values/strings.xml \
  Feature/Sources/ReminderFeature/Resources/Localizable.xcstrings
