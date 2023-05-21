const {exec, execSync} = require('child_process');

execSync('docker run --rm -v C:\\Users\\johlun\\WebstormProjects\\pandemic\\wasm:/wasm -v C:\\Users\\johlun\\WebstormProjects\\pandemic\\src:/src -w /wasm rfdf-wasm:latest /wasm/build.sh');

