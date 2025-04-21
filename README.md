# DJI Thermal SDK Docker image

![](https://img.shields.io/badge/version-v1.7-red.svg)

Dockerized [DJI Thermal SDK](https://www.dji.com/downloads/softwares/dji-thermal-sdk), which includes example tools for processing and measuring some DJI thermal images.

## Installation

```sh
docker build -t djithermal .
```

If you're on a different architecture, eg Apple Silicon, you might need to specify the platform.

```sh
docker build --platform linux/amd64 -t djithermal .
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
  -v "$(pwd):/work" -w /work \
  djithermal \
  /bin/sh -c '
    export i=/app/djithermal/dataset/H30T/DJI_0001_R.JPG
    dji_irp -a process \
      --palette iron_red \
      --colorbar on,40,10 \
      --source $i \
      --output process.rgb
    export resolution=$(identify -format "%wx%h" "$i")
    convert -depth 8 -size $resolution RGB:process.rgb process.jpg'
```

## Extract a raw float32 thermal

```sh
docker run -i \
  -v "$(pwd):/work" -w /work \
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
  -v "$(pwd):/work" -w /work \
  djithermal \
  /bin/sh -c 'mkdir -p process && mkdir -p raw
  for i in *.JPG; do
    dji_irp -a process \
      --palette iron_red \
      --colorbar on,44,0 \
      --source "$i" \
      --output "$(pwd)/process/$(basename $i .JPG).rgb"
    resolution=$(identify -format "%wx%h" "$i")
    convert -depth 8 -size $resolution \
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
