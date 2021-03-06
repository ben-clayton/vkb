:: Copyright 2019 The VKB Authors.
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::     http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo on

set BUILD_ROOT=%cd%
set SRC=%cd%\github\vkb
set BUILD_TYPE=%1

choco install cmake --yes --no-progress
choco upgrade cmake --yes --no-progress

:: Force usage of python 3.6 and add cmake to the path.
set PATH=C:\python36;"C:\Program Files\CMake\bin";%PATH%

cd %SRC%
python tools\git-sync-deps

:: #########################################
:: set up msvc build env
:: #########################################
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
echo "Using VS 2017..."

cmake --version

cd %SRC%
mkdir build
cd build

:: #########################################
:: Start building.
:: #########################################
echo "Starting build... %DATE% %TIME%"
if "%KOKORO_GITHUB_COMMIT%." == "." (
  set BUILD_SHA=%KOKORO_GITHUB_PULL_REQUEST_COMMIT%
) else (
  set BUILD_SHA=%KOKORO_GITHUB_COMMIT%
)

cmake -GNinja -DCMAKE_BUILD_TYPE=%BUILD_TYPE% -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe ..
if %ERRORLEVEL% GEQ 1 exit /b %ERRORLEVEL%

echo "Build everything... %DATE% %TIME%"
ninja
if %ERRORLEVEL% GEQ 1 exit /b %ERRORLEVEL%
echo "Build Completed %DATE% %TIME%"

:: #########################################
:: Run the tests
:: ##########################################
set CTEST_OUTPUT_ON_FAILURE=1

echo "Running ctest... %DATE% %TIME%"
ctest -E "vk_.*_validation_tests"
if %ERRORLEVEL% GEQ 1 exit /b %ERRORLEVEL%
echo "ctest Completed %DATE% %TIME%"

exit /b %ERRORLEVEL%
