#!/bin/bash -x

set -eu

PROJECT_ROOT_DIR=$(cd $(dirname $0)/../..; pwd)
cd $PROJECT_ROOT_DIR
pwd

bundle install

# convert strings.xml to Localizable.xcstrings
echo "↔️  Converting strings.xml to Localizable.xcstrings..."
iosApp/scripts/generate-strings.rb \
  features/reminder/src/androidMain/res/values-ja/strings.xml \
  features/reminder/src/androidMain/res/values/strings.xml \
  iosApp/Feature/Sources/ReminderFeature/Resources/Localizable.xcstrings
