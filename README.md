# DJI Thermal SDK Docker image

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
  --colorbar on,44,0 \
  -s DJI_0001_R.JPG -o process.raw
  convert -depth 8 -size 640x512 RGB:process.raw result.jpg
  rm process.raw
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
    -s DJI_0001_R.JPG -o measure.raw
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
    -s "$i" -o "$(pwd)/process/$(basename $i .JPG).raw"
    convert -depth 8 -size 640x512 RGB:"$(pwd)/process/$(basename $i .JPG).raw" "$(pwd)/process/$(basename $i)"
    rm "$(pwd)/process/$(basename $i .JPG).raw"
  done'
```
