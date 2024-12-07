echo "build SharedKit.xcframework ..."
PROJECT_DIR=${PROJECT_DIR:-$(cd $(dirname $0)/..; pwd)}
cd $PROJECT_DIR/..
./gradlew assembleSharedKitDebugXCFramework