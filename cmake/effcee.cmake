# Copyright 2019 The VKB Authors
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

message(STATUS "VKB Effcee: ${VKB_EFFCEE_SOURCE_DIR}")

option(EFFCEE_BUILD_TESTING "Enable testing for Effcee" OFF)
option(EFFCEE_BUILD_SAMPLES "Enable samples for Effcee" OFF)

add_subdirectory(${VKB_EFFCEE_SOURCE_DIR} EXCLUDE_FROM_ALL)
