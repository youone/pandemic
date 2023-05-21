#!/usr/bin/env bash

emcc --version
emcc --bind -O3 \
-s WASM=1 \
-s DISABLE_EXCEPTION_CATCHING=0 \
-s ALLOW_MEMORY_GROWTH=1 \
-s EXPORTED_RUNTIME_METHODS="['ccall', 'cwrap', 'intArrayFromString', 'allocate', 'ALLOC_NORMAL', 'UTF8ToString', 'writeArrayToMemory']" \
-s MODULARIZE=1 \
-s EXPORT_NAME="pandemicModule" \
-s ASSERTIONS=1 \
-s SINGLE_FILE=1 \
-o /wasm/pandemic_wasm.js \
/wasm/pandemic.cpp

mv /wasm/pandemic_wasm.js /src

#-I/src/native \
#-I/rfdf/GeographicLib-1.52/include \
#-I/usr/include/eigen3 \
