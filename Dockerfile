FROM ubuntu
ENV DEBIAN_FRONTEND=noninteractive

ARG URL="https://dl.djicdn.com/downloads/dji_assistant/20201125/dji_thermal_sdk_v1.0_20201110.zip"
ARG DJI_THERMAL_DIR="dji_thermal_sdk_v1.0_20201110"

COPY diff.patch /tmp/

RUN set -ex \
  && apt-get update \
  && apt-get -y install wget g++ gcc cmake unzip libc-dev patch imagemagick exiftool

RUN set -ex \
  && mkdir -p /app \
  && mkdir -p /usr/src \
  && cd /usr/src \
  && wget "$URL" -O file.zip \
  && unzip file.zip \
  && patch "/usr/src/$DJI_THERMAL_DIR/tsdk-core/api/dirp_api.h" /tmp/diff.patch \
  && cd "/usr/src/$DJI_THERMAL_DIR/sample" \
  && chmod +x build.sh \
  && ./build.sh \
  && cp build/Release_x64/dji_* /usr/bin
