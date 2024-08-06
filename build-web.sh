#!/bin/bash

set -e

export OPTIMIZE="-Os"
export LDFLAGS="${OPTIMIZE}"
export CFLAGS="${OPTIMIZE}"
export CPPFLAGS="${OPTIMIZE}"

echo "============================================="
echo "Compiling wasm bindings"
echo "============================================="
(
  # Compile C/C++ code
  emcc \
    -std=c++11 \
    -DXA_MULTITHREADED=0 \
    -DNDEBUG \
    ${OPTIMIZE} \
    --bind \
    --no-entry \
    -s STRICT=1 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s MALLOC=emmalloc \
    -lc++abi \
    -s MODULARIZE=1 \
    -s ENVIRONMENT='web,worker' \
    -s ASSERTIONS=1 \
    --post-js './web/module-post.js' \
    -o ./xatlas-web.js \
    web/*.cpp \
    source/xatlas/xatlas.cpp

  # Create output folder
  mkdir -p dist
  # Move artifacts
  mv xatlas-web.{js,wasm} dist
)
echo "============================================="
echo "Compiling wasm bindings done"
echo "============================================="