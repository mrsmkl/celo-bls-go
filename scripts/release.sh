#!/bin/bash -e

DIRECTORY=./libs
if [[ -d "$DIRECTORY" ]]
then
    echo "$DIRECTORY exists on your filesystem. Delete it and run the script again."
    exit 0
fi

pushd celo-bls-snark-rs

cargo install cargo-lipo

rustup default 1.42.0
rustup target add i686-unknown-linux-gnu
rustup target add x86_64-unknown-linux-gnu
rustup target add arm-unknown-linux-gnueabi
rustup target add arm-unknown-linux-gnueabihf
rustup target add aarch64-unknown-linux-gnu
rustup target add mips-unknown-linux-gnu
rustup target add mipsel-unknown-linux-gnu
rustup target add mips64-unknown-linux-gnuabi64
rustup target add mips64el-unknown-linux-gnuabi64
rustup target add x86_64-apple-darwin
rustup target add i686-pc-windows-gnu
rustup target add x86_64-pc-windows-gnu
rustup target add aarch64-linux-android
rustup target add armv7-linux-androideabi
rustup target add i686-linux-android
rustup target add x86_64-linux-android
rustup target add x86_64-unknown-linux-musl

cargo build --release --target=aarch64-linux-android --lib
cargo build --release --target=armv7-linux-androideabi --lib
cargo build --release --target=i686-linux-android --lib
cargo build --release --target=x86_64-linux-android --lib
cargo build --release
cargo build --target=i686-unknown-linux-gnu --release
cargo build --target=x86_64-unknown-linux-gnu --release
cargo build --target=arm-unknown-linux-gnueabi --release
cargo build --target=arm-unknown-linux-gnueabihf --release
cargo build --target=aarch64-unknown-linux-gnu --release
cargo build --target=mips-unknown-linux-gnu --release
cargo build --target=mipsel-unknown-linux-gnu --release
cargo build --target=mips64-unknown-linux-gnuabi64 --release
cargo build --target=mips64el-unknown-linux-gnuabi64 --release
cargo build --target=x86_64-apple-darwin --release
cargo build --target=i686-pc-windows-gnu --release
cargo build --target=x86_64-pc-windows-gnu --release
cargo build --target=x86_64-unknown-linux-musl --release

rustup default 1.41.0
rustup target add i686-apple-darwin
rustup target add armv7-apple-ios i386-apple-ios aarch64-apple-ios x86_64-apple-ios
cargo build --target=i686-apple-darwin --release
cargo lipo --release --targets=aarch64-apple-ios,armv7-apple-ios,x86_64-apple-ios,i386-apple-ios

popd 

TOOLS_DIR=`dirname $0`
COMPILE_DIR=${TOOLS_DIR}/../celo-bls-snark-rs/target
for platform in `ls ${COMPILE_DIR} | grep -v release | grep -v debug`
do
  PLATFORM_DIR=${DIRECTORY}/$platform
  mkdir -p ${PLATFORM_DIR}
  LIB_PATH=${COMPILE_DIR}/$platform/release/libbls_snark_sys.a
  if [[ -f ${LIB_PATH} ]]
  then
    cp ${COMPILE_DIR}/$platform/release/libbls_snark_sys.a ${PLATFORM_DIR}
  fi
  WINDOWS_LIB_PATH=${COMPILE_DIR}/$platform/release/bls_snark_sys.lib
  if [[ -f ${WINDOWS_LIB_PATH} ]]
  then
    cp ${COMPILE_DIR}/$platform/release/bls_snark_sys.lib ${PLATFORM_DIR}
  fi
done

tar czf libs.tar.gz libs
