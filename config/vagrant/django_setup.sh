#!/bin/bash


VENV_NAME=$1

echo "=== Begin Vagrant Provisioning using 'config/vagrant/django_setup.sh'"

workon $VENV_NAME

if [[ -f /vagrant/manage.py ]]; then

	su - vagrant -c "source /home/vagrant/.virtualenvs/$VENV_NAME/bin/activate && cd /vagrant && ./manage.py migrate"

	su - vagrant -c "source /home/vagrant/.virtualenvs/$VENV_NAME/bin/activate && cd /vagrant && ./manage.py collectstatic --noinput"

fi

echo "=== End Vagrant Provisioning using 'config/vagrant/django_setup.sh'"


