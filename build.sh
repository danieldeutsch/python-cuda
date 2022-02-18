#!/bin/bash

IMAGE_BASE_NAME="danieldeutsch/python"

set -e

cat readme_header.md >README_.md

echo -e "## Supported tags\n" >>README_.md

for py in "3.6" "3.7" "3.8" "3.9"; do
    echo -e "### Python $py\n" >>README_.md
    for cuda in "11.0.3"; do
        echo -e "#### CUDA ${cuda}\n" >>README_.md
        IMAGE_PREFIX="${IMAGE_BASE_NAME}:${py}"


        echo "Building ${IMAGE_PREFIX}-cuda${cuda}-base"
        docker build \
            --quiet \
            --build-arg PY="${py}" \
            --tag "${IMAGE_PREFIX}-cuda${cuda}-base" \
            "${cuda}/base"
        echo

        echo "Pushing images to repository"
        docker push "${IMAGE_PREFIX}-cuda${cuda}-base"
        echo

echo "- [\`${IMAGE_PREFIX}-cuda${cuda}-base\` (*${cuda}/base/Dockerfile*)](https://github.com/danieldeutsch/python-cuda/blob/master/${cuda}/base/Dockerfile)" >>README_.md
echo "" >>README_.md

    done
done

mv -f README_.md README.md
