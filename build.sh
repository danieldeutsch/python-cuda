#!/bin/bash

IMAGE_BASE_NAME="danieldeutsch/python"
VERSION="v2"

set -e

cat readme_header.md >README_.md

echo -e "## Supported tags\n" >>README_.md

for py in "3.6" "3.7" "3.8" "3.9"; do
    echo -e "### Python $py\n" >>README_.md
    for cuda in "10.1" "10.2" "11.0.3" "11.1.1"; do
        echo -e "#### CUDA ${cuda}\n" >>README_.md
        IMAGE_PREFIX="${IMAGE_BASE_NAME}:${py}"
        TAG="${IMAGE_PREFIX}-cuda${cuda}-base-${VERSION}"

        echo "Building ${TAG}"
        docker build \
            --quiet \
            --build-arg PY="${py}" \
            --tag ${TAG} \
            "${cuda}/base"
        echo

        echo "Pushing images to repository"
        docker push "${TAG}"
        echo

echo "- [\`${TAG}\` (*${cuda}/base/Dockerfile*)](https://github.com/danieldeutsch/python-cuda/blob/master/${cuda}/base/Dockerfile)" >>README_.md
echo "" >>README_.md

    done
done

mv -f README_.md README.md
