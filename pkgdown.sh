#!/bin/bash
set -ev
if [ "${RELEASE_VERSION}" != "" ]; then
    git clone --branch src https://${GH_TOKEN}@github.com/Crunch-io/ta-da.git ../ta-da
    rm -rf ../ta-da/static/r/crunchy
    cp -r docs/. ../ta-da/static/r/crunchy
    cd ../ta-da
    git add .
    git commit -m "Updating crunchy pkgdown site (release ${RELEASE_VERSION})" || true
    git push origin src || true
fi
