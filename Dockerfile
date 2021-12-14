FROM gcc:latest

ARG URL="https://dl.djicdn.com/downloads/dji_thermal_sdk/20211119/dji_thermal_sdk_v1.1_20211029.zip"

COPY diff.patch /tmp/

RUN apt-get update
RUN apt-get -y install bash wget unzip cmake patch imagemagick exiftool dos2unix

RUN set -ex \
  && mkdir -p /usr/src/djithermal \
  && cd /usr/src/djithermal \
  && wget "$URL" -O dji_thermal_sdk.zip \
  && unzip dji_thermal_sdk.zip \
  && patch "tsdk-core/api/dirp_api.h" /tmp/diff.patch \
  && dos2unix sample/build.sh \
  && chmod +x sample/build.sh \
  && ./sample/build.sh \
  && cp tsdk-core/lib/linux/release_x64/*.so /usr/lib \
  && cp sample/build/Release_x64/dji_* /usr/bin
