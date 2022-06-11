FROM gcc:12

ARG URL="https://dl.djicdn.com/downloads/dji_thermal_sdk/20220523/dji_thermal_sdk_v1.3_20220517.zip"
COPY <<"EOF1" /tmp/diff.patch
diff -Naur dji_thermal_sdk_v1.3_20220517/sample/dji_ircm.cpp dji_thermal_sdk_v1.3_20220517_patched/sample/dji_ircm.cpp
--- dji_thermal_sdk_v1.3_20220517/sample/dji_ircm.cpp	2022-05-17 19:38:50.000000000 +1000
+++ dji_thermal_sdk_v1.3_20220517_patched/sample/dji_ircm.cpp	2022-06-12 00:09:54.000000000 +1000
@@ -29,6 +29,7 @@
 #include <iterator>
 #include <vector>
 #include <string.h>
+#include <math.h>
 #include <sys/stat.h>
 
 #include "dirp_api.h"
EOF1

RUN apt-get update
RUN apt-get -y install bash wget unzip cmake patch imagemagick exiftool

RUN <<"EOF2"
mkdir -p /usr/src/djithermal
cd /usr/src/djithermal
wget "$URL" -O dji_thermal_sdk.zip
unzip dji_thermal_sdk.zip
patch -s -p1 < /tmp/diff.patch
chmod +x sample/build.sh
./sample/build.sh
cp tsdk-core/lib/linux/release_x64/*.so /usr/lib
cp sample/build/Release_x64/dji_* /usr/bin
EOF2