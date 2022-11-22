# DJI Thermal SDK Docker image

![](https://img.shields.io/badge/version-v1.4-red.svg)

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
    --colorbar on,40,25 \
    --source /app/djithermal/dataset/M30T/DJI_0001_R.JPG \
    --output process.rgb
convert -depth 8 -size 640x512 RGB:process.rgb process.jpg
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
    --source DJI_0001_R.JPG \
    --output measure.raw
```

## Process all images in the current directory, copying exif metadata from the original file

```sh
docker run -i \
  -v "$(pwd)":"$(pwd)" -w "$(pwd)" \
  djithermal \
  /bin/sh -c 'mkdir -p process && mkdir -p raw
  for i in *.JPG; do
    dji_irp -a process \
      --palette iron_red \
      --colorbar on,44,0 \
      --source "$i" \
      --output "$(pwd)/process/$(basename $i .JPG).rgb"
    convert -depth 8 -size 640x512 \
      RGB:"$(pwd)/process/$(basename $i .JPG).rgb" \
      "$(pwd)/process/$(basename $i)"
    rm "$(pwd)/process/$(basename $i .JPG).rgb"
    exiftool -overwrite_original -TagsFromFile "$i" -all:all "$(pwd)/process/$(basename $i)"
    dji_irp -a measure \
      --measurefmt float32 \
      --distance 25 \
      --humidity 77 \
      --emissivity 0.98 \
      --reflection 23 \
      --source "$i" \
      --output "$(pwd)/raw/$(basename $i .JPG).raw"
  done'
```
