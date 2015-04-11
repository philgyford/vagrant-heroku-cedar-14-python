#!/bin/bash

# Install and (if there's a Procfile) start foreman.
# Needs to come after the virtualenv has been set up.

# Expects one argument, the name of the virtualenv.

VIRTUALENV_NAME=$1

echo "=== Begin Vagrant Provisioning using 'config/vagrant/foreman_setup.sh'"

gem install foreman --no-ri --no-rdoc

if [[ -f /vagrant/Procfile ]]; then
    # We need to re-set these, as they don't seem to carry over from
    # virtualenv_setup.sh
    # But they need to be done so that the gunicorn called in the Procfile
    # will be found (it was installed in the virtualenv).
    WORKON_HOME=/home/vagrant/.virtualenvs
    PROJECT_HOME=/home/vagrant/Devel
    source /usr/local/bin/virtualenvwrapper.sh
    workon $VIRTUALENV_NAME

    foreman start -f /vagrant/Procfile
else
    echo "No Procfile found; not starting foreman."
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/forematn_setup.sh'"
