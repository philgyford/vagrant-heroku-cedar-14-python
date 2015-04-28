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
if ! grep -Fq "WORKON_HOME" /home/vagrant/.profile; then
    echo "Adding virtualenvwrapper locations to .profile"

    echo "export WORKON_HOME=/home/vagrant/.virtualenvs" >> /home/vagrant/.profile
    echo "export PROJECT_HOME=/home/vagrant/Devel" >> /home/vagrant/.profile
    echo "source /usr/local/bin/virtualenvwrapper.sh" >> /home/vagrant/.profile
fi

# Get .virtualenvwrapper env variables set up:
source /home/vagrant/.profile

if [[ -d /home/vagrant/.virtualenvs/$VIRTUALENV_NAME ]]; then
    echo "Activating virtualenv $VIRTUALENV_NAME."
    workon $VIRTUALENV_NAME
else
    echo "Making new virtualenv $VIRTUALENV_NAME."
    # Also switches to the virtualenv:
    mkvirtualenv $VIRTUALENV_NAME

	# So that we can install things with pip while ssh'd in as vagrant user:
	sudo chown -R vagrant:vagrant /home/vagrant/.virtualenvs/$VIRTUALENV_NAME/

    # Automatically switch to the virtual env on log in:
    echo "workon $VIRTUALENV_NAME" >> /home/vagrant/.profile
fi

# If we have a requirements.txt file in this project, then install
# everything in it with pip in a new virtualenv.
if [[ -f /vagrant/requirements.txt ]]; then
    echo "Installing from ./requirements.txt with pip."
    pip install -r /vagrant/requirements.txt
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/virtualenv_setup.sh'"
