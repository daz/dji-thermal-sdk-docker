# DJI Thermal SDK Docker image

Dockerized [DJI Thermal SDK](https://www.dji.com/downloads/softwares/dji-thermal-sdk), which includes example tools for processing and measuring some DJI thermal images.

## Installation

```sh
docker build -t djithermal .                        
```

If you're on Apple silicon or a non-x86 CPU you can specify the platform with `docker buildx`:

```sh
docker buildx install
docker buildx build --platform linux/amd64 --load -t djithermal .
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
    --output process.raw
convert -depth 8 -size 640x512 RGB:process.raw process.jpg
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

## Or process all images in the current directory

```sh
docker run -i \
  -v "$(pwd)":"$(pwd)" -w "$(pwd)" \
  djithermal \
  /bin/sh -c 'mkdir -p process
  for i in *.JPG; do
    dji_irp -a process \
      --palette iron_red \
      --colorbar on,44,0 \
      --source "$i" \
      --output "$(pwd)/process/$(basename $i .JPG).raw"
    convert -depth 8 -size 640x512 \
      RGB:"$(pwd)/process/$(basename $i .JPG).raw" \
      "$(pwd)/process/$(basename $i)"
    rm "$(pwd)/process/$(basename $i .JPG).raw"
  done'
```
