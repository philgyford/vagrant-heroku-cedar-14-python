#!/bin/bash

# This will:
# * Install pip, virtualenv and virtualenvwrapper.
# * Set up virtualenvwrapper's paths etc.
# * Create a new virtualenv.
# * Install any pip requirements from the requirements.txt file.


# Becacuse $HOME is /root:
VAGRANT_HOME=/home/vagrant

# The name we'll use for the virtualenv in which we'll install requirements:
VIRTUALENV_NAME=myvirtualenv

# Path to .bashrc:
BASHRC_PATH=$VAGRANT_HOME/.bashrc


echo "=== Begin Vagrant Provisioning using 'config/vagrant/virtualenv_setup.sh'"

# virtualenv global setup
if ! command -v pip; then
    easy_install -U pip
fi

if [[ ! -f /usr/local/bin/virtualenv ]]; then
    easy_install virtualenv virtualenvwrapper
fi

# If it doesn't look like .bashrc has the required virtualenvwrapper lines in,
# then add them. So we don't add them every time we provision.
if ! grep -Fq "WORKON_HOME" $BASHRC_PATH; then
    echo "Adding virtualenvwrapper locations to $BASHRC_PATH"

    echo '' >> $BASHRC_PATH
    echo 'export WORKON_HOME=$HOME/.virtualenvs' >> $BASHRC_PATH
    echo 'export PROJECT_HOME=$HOME/Devel' >> $BASHRC_PATH
    echo 'source /usr/local/bin/virtualenvwrapper.sh' >> $BASHRC_PATH
fi

# Doing `source $BASHRC_PATH` won't work, so we need to explicitly repeat
# what we've put in .bashrc:
WORKON_HOME=$VAGRANT_HOME/.virtualenvs
PROJECT_HOME=$VAGRANT_HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh

# If we have a requirements.txt file in this project, then install
# everything in it with pip in a new virtualenv.
if [[ -f /vagrant/requirements.txt ]]; then
    echo "Making new virtualenv $VIRTUALENV_NAME"
    echo "    and installing from ./requirements.txt with pip."
    mkvirtualenv $VIRTUALENV_NAME -r /vagrant/requirements.txt
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/virtualenv_setup.sh'"
