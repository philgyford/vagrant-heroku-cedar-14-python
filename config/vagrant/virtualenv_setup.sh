#!/bin/bash

# This will:
# * Install pip, virtualenv and virtualenvwrapper.
# * Set up virtualenvwrapper's paths etc.
# * Create a new virtualenv.
# * Install any pip requirements from the requirements.txt file.

# Expects one argument, the name of the virtualenv.

# The name we'll use for the virtualenv in which we'll install requirements:
VIRTUALENV_NAME=$1

echo "=== Begin Vagrant Provisioning using 'config/vagrant/virtualenv_setup.sh'"

# virtualenv global setup
if ! command -v pip; then
    easy_install -U pip
fi

if [[ ! -f /usr/local/bin/virtualenv ]]; then
    easy_install virtualenv virtualenvwrapper
fi

# If it doesn't look like .bashrc has the required virtualenvwrapper lines in,
# then add them.
if ! grep -Fq "WORKON_HOME" /home/vagrant/.bashrc; then
    echo "Adding virtualenvwrapper locations to .bashrc"

    echo "export WORKON_HOME=$HOME/.virtualenvs" >> /home/vagrant/.bashrc
    echo "export PROJECT_HOME=$HOME/Devel" >> /home/vagrant/.bashrc
    echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/vagrant/.bashrc
fi

# Doing `source /home/vagrant/.bashrc` won't work; we need to explicitly repeat
# what we've put in .bashrc:
WORKON_HOME=/home/vagrant/.virtualenvs
PROJECT_HOME=/home/vagrant/Devel
source /usr/local/bin/virtualenvwrapper.sh

if [[ -d /vagrant/home/.virtualenvs/$VIRTUALENV_NAME ]]; then
    echo "Activating virtualenv $VIRTUALENV_NAME."
    workon $VIRTUALENV_NAME
else
    echo "Making new virtualenv $VIRTUALENV_NAME."
    mkvirtualenv $VIRTUALENV_NAME
fi

# If we have a requirements.txt file in this project, then install
# everything in it with pip in a new virtualenv.
if [[ -f /vagrant/requirements.txt ]]; then
    echo "Installing from ./requirements.txt with pip."
    pip install -r /vagrant/requirements.txt
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/virtualenv_setup.sh'"
