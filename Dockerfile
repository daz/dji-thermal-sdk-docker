# syntax=docker/dockerfile:1
FROM --platform=linux/amd64 ubuntu:22.04

ARG URL="https://dl.djicdn.com/downloads/dji_thermal_sdk/20221108/dji_thermal_sdk_v1.4_20220929.zip"

COPY <<"EOF1" /tmp/diff.patch
diff -Naur dji_thermal_sdk_v1.4_20220929/sample/dji_ircm.cpp dji_thermal_sdk_v1.4_20220929_patched/sample/dji_ircm.cpp
--- dji_thermal_sdk_v1.4_20220929/sample/dji_ircm.cpp	2022-09-29 06:47:04
+++ dji_thermal_sdk_v1.4_20220929_patched/sample/dji_ircm.cpp	2022-11-19 02:02:36
@@ -29,6 +29,7 @@
 #include <iterator>
 #include <vector>
 #include <string.h>
+#include <math.h>
 #include <sys/stat.h>
 
 #include "dirp_api.h"
EOF1

RUN apt-get update
RUN apt-get -y install wget unzip cmake libc6-dev-i386 g++-multilib patch imagemagick exiftool

RUN <<"EOF2"
mkdir -p /app/djithermal
cd /app/djithermal
wget "$URL" -O dji_thermal_sdk.zip
unzip dji_thermal_sdk.zip
patch -s -p1 < /tmp/diff.patch
chmod +x sample/build.sh
./sample/build.sh
cp sample/build/Release_x64/*.so /usr/lib
cp sample/build/Release_x64/dji_* /usr/bin
EOF2
