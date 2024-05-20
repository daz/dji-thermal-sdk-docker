# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ARG URL="https://terra-1-g.djicdn.com/2640963bcd8e45c0a4f0cb9829739d6b/TSDK/v1.7(12.0-WA345T)/dji_thermal_sdk_v1.7_20241205.zip"

RUN apt-get update && \
    apt-get -y install wget unzip cmake build-essential imagemagick exiftool patchelf

WORKDIR /app/djithermal

RUN wget "$URL" -O dji_thermal_sdk.zip && \
    unzip dji_thermal_sdk.zip && \
    sh sample/build.sh

# Copy executables and libraries to system paths
RUN cp /app/djithermal/sample/build/Release_x64/dji_* /bin && \
    cp /app/djithermal/sample/build/Release_x64/*.so /lib && \
    cp /app/djithermal/tsdk-core/lib/linux/release_x64/* /lib

# Fix RPATH to ensure binaries use libraries from /lib
RUN for bin in /bin/dji_*; do patchelf --set-rpath /lib "$bin"; done
