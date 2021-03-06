#!/bin/bash
# Copyright 2019 The VKB Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e  # fail on error
set -x  # show commands

BUILD_ROOT=$PWD
SRC=$PWD/github/vkb
BUILD_TYPE=$1

# Get ninja
wget -q https://github.com/ninja-build/ninja/releases/download/v1.8.2/ninja-mac.zip
unzip -qq ninja-mac.zip
chmod +x ninja
export PATH="$PWD:$PATH"

echo $(date): $(cmake --version)

cd $SRC
./tools/git-sync-deps

mkdir build && cd $SRC/build

CMAKE_C_CXX_COMPILER="-DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++"

# Invoke the build.
BUILD_SHA=${KOKORO_GITHUB_COMMIT:-$KOKORO_GITHUB_PULL_REQUEST_COMMIT}
echo $(date): Starting build...
cmake -GNinja -DCMAKE_BUILD_TYPE=$BUILD_TYPE $CMAKE_C_CXX_COMPILER ..

echo $(date): Build everything...
ninja
echo $(date): Build completed.

export CTEST_OUTPUT_ON_FAILURE=1

echo $(date): Starting ctest...
ctest -E "vk_.*_validation_tests"
echo $(date): ctest completed.
