#!/usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

printf "Checking for required npm version...\n"
sudo apt remove -y npm nodejs
wget https://nodejs.org/dist/v16.17.1/node-v16.17.1-linux-x64.tar.xz
sudo apt-get install xz-utils
sudo mkdir /usr/local/npm
sudo tar -C /usr/local --strip-components 1 -xJf node-v16.17.1-linux-x64.tar.xz
sudo ln -s /usr/local/npm/bin/node /usr/bin/node
sudo ln -s /usr/local/npm/bin/npm /usr/bin/npm
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
printf "Completed.\n\n"

set -eEo pipefail

if [ ! -z "$CLOUD_SHELL" ]
then
  printf "Setting up NVM...\n"
  export NVM_DIR="/usr/local/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  printf "Completed.\n\n"
  
  printf "Updating nodeJS version...\n"
  nvm install --lts
  printf "Completed.\n\n"
fi

printf "Installing monolith dependencies...\n"
cd ./monolith
npm install
printf "Completed.\n\n"

printf "Installing microservices dependencies...\n"
cd ../microservices
npm install
printf "Completed.\n\n"

printf "Installing React app dependencies...\n"
cd ../react-app
npm install
printf "Completed.\n\n"

printf "Building React app and placing into sub projects...\n"
npm run build
printf "Completed.\n\n"

printf "Setup completed successfully!\n"

if [ ! -z "$CLOUD_SHELL" ]
then
  printf "\n"
  printf "###############################################################################\n"
  printf "#                                   NOTICE                                    #\n"
  printf "#                                                                             #\n"
  printf "# Make sure you have a compatible nodeJS version with the following command:  #\n"
  printf "#                                                                             #\n"
  printf "# nvm install --lts                                                           #\n"
  printf "#                                                                             #\n"
  printf "###############################################################################\n"
fi
