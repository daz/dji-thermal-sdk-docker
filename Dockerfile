FROM gcc:12

ARG URL="https://dl.djicdn.com/downloads/dji_thermal_sdk/20220523/dji_thermal_sdk_v1.3_20220517.zip"

COPY diff.patch /tmp/

RUN apt-get update
RUN apt-get -y install bash wget unzip cmake patch imagemagick exiftool

RUN set -ex \
  && mkdir -p /usr/src/djithermal \
  && cd /usr/src/djithermal \
  && wget "$URL" -O dji_thermal_sdk.zip \
  && unzip dji_thermal_sdk.zip \
  && patch -s -p1 < /tmp/diff.patch \
  && chmod +x sample/build.sh \
  && ./sample/build.sh \
  && cp tsdk-core/lib/linux/release_x64/*.so /usr/lib \
  && cp sample/build/Release_x64/dji_* /usr/bin
