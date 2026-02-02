# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ARG URL="https://terra-1-g.djicdn.com/2640963bcd8e45c0a4f0cb9829739d6b/TSDK/v1.8(16.1)/dji_thermal_sdk_v1.8_20250829.zip"

RUN apt-get update && \
    apt-get -y install wget unzip cmake build-essential dos2unix imagemagick exiftool

WORKDIR /app/djithermal

RUN wget "$URL" -O dji_thermal_sdk.zip && \
    unzip dji_thermal_sdk.zip

# Don't build 32-bit
RUN rm -rf tsdk-core/lib/linux/debug_x86 \
    tsdk-core/lib/linux/release_x86

# Fix line endings
RUN dos2unix sample/build.sh

RUN sh sample/build.sh

# Copy executables and libraries to system paths
RUN cp /app/djithermal/sample/build/Release_x64/dji_* /bin && \
    cp /app/djithermal/sample/build/Release_x64/*.so /lib && \
    cp /app/djithermal/tsdk-core/lib/linux/release_x64/* /lib
