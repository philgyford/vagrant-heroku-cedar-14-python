# Vagrant Heroku cedar-14 box for python/Django

A Vagrant box for python/Django development, mimicking a Heroku cedar-14 dyno.

* Ubuntu 14.04 (ubuntu/trusty64)
* PostgreSQL 9.4
* python 2.7.6
* pip, virtualenv, virtualenvwrapper
* Requirements for Pillow
* foreman

It will make a new virtualenv (`myvirtualenv`).

If a `requirements.txt` file is found, modules in it will be installed into the virtualenv.

If a `Procfile` is found, foreman will be started.

Database username: `postgres_db`
Password: `postgres_db`


#### Useful / Inspired by:

* https://github.com/kiere/vagrant-heroku-cedar-14/
* https://github.com/ejholmes/vagrant-heroku/
* https://github.com/torchbox/vagrant-django-base/
* https://github.com/torchbox/vagrant-django-template
* https://github.com/jackdb/pg-app-dev-vm/
* https://github.com/maigfrga/django-vagrant-chef/
* https://devcenter.heroku.com/articles/cedar-ubuntu-packages

