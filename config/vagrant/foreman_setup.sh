#!/bin/bash

# Install and (if there's a Procfile) start foreman.


echo "=== Begin Vagrant Provisioning using 'config/vagrant/foreman_setup.sh'"

gem install foreman --no-ri --no-rdoc

if [[ -f /vagrant/Procfile ]]; then
	foreman start
else
	echo "No Procfile found; not starting foreman."
fi

echo "=== End Vagrant Provisioning using 'config/vagrant/forematn_setup.sh'"
