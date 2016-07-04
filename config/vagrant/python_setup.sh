#!/bin/bash

# Install python and required python modules.
# pip and virtualenv are in virtualenv_setup.sh

# Initial part of this via
# https://github.com/torchbox/vagrant-django-base/blob/master/install.sh

echo "=== Begin Vagrant Provisioning using 'config/vagrant/python_setup.sh'"

apt-get update -y

# Python dev packages
apt-get install -y python python-dev python-setuptools python-pip

# Install Python 3 if the runtime.txt file specifies it.
if [[ -f /vagrant/runtime.txt ]]; then
  python_runtime=$(head -n 1 /vagrant/runtime.txt)
  if [[ $python_runtime =~ ^python-3\.5 ]]; then
    # Python 3.5 not yet in the official repositories list, so use this:
    add-apt-repository ppa:fkrull/deadsnakes
    apt-get update
    apt-get install -y python3.5 python3.5-dev
  fi
fi

# Dependencies for image processing with Pillow (drop-in replacement for PIL)
# supporting: jpeg, tiff, png, freetype, littlecms
apt-get install -y libjpeg-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev

echo "=== End Vagrant Provisioning using 'config/vagrant/python_setup.sh'"
