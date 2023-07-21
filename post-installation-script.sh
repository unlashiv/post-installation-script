#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt-get --assume-yes update
sudo apt-get --assume-yes install git
cd ~
git clone https://github.com/unlashiv/post-installation-script.git
cd post-installation-script
bash setup.sh