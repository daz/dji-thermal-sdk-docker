# DJI Thermal SDK Docker image

Dockerized [DJI Thermal SDK](https://www.dji.com/downloads/softwares/dji-thermal-sdk), which includes example tools for processing and measuring some DJI thermal images.

## Installation

```sh
docker build -t djithermal .                        
```

## Commands

```sh
docker run -i \
  djithermal \
  dji_irp --help
```

## Process an image to psuedocolor

```sh
docker run -i \
  -v "$(pwd)":"$(pwd)" -w "$(pwd)" \
  djithermal \
  dji_irp -a process \
  --palette iron_red \
  --colorbar on,17,11 \
  -s DJI_20210609020428_0437_T.JPG -o process.raw
  magick -depth 8 -size 640x512 RGB:process.raw result.jpg
```

## Extract a raw float32 thermal

```sh
docker run -i \
  -v "$(pwd)":"$(pwd)" -w "$(pwd)" \
  djithermal \
  dji_irp -a measure \
    --measurefmt float32 \
    --distance 25 \
    --humidity 77 \
    --emissivity 0.98 \
    --reflection 23 \
    -s DJI_20210609020428_0437_T.JPG -o measure.raw
```

## Or process all images in the current directory

```sh
docker run -i \
  -v "$(pwd)":"$(pwd)" -w "$(pwd)" \
  djithermal \
  /bin/sh -c 'for i in *.JPG; do
    dji_irp -a process \
    --palette iron_red \
    --colorbar on,17,11 \
    -s "$i" -o "$(pwd)/process/$(basename $i .JPG).raw"
    magick -depth 8 -size 640x512 RGB:"$(pwd)/process/$(basename $i .JPG).raw" "$(pwd)/process/$(basename $i)"
    rm "$(pwd)/process/$(basename $i .JPG).raw"
  done'
```
