A work in progress. Trying to make a Vagrant box for python/Django development, mimicking a Heroku cedar-14 dyno.

So far:

* Ubuntu 14.04
* PostgreSQL 9.4
* python 2.7.6
* Requirements for Pillow
* pip, virtualenv, virtualenvwrapper
* foreman

It will make a new virtualenv (`myvirtualenv`)

If a `requirements.txt` file is found, modules in it will be installed into the virtualenv.

If a `Procfile` is found, foreman will be started.


Useful:

* https://devcenter.heroku.com/articles/cedar-ubuntu-packages
* https://github.com/ejholmes/vagrant-heroku/
* https://github.com/kiere/vagrant-heroku-cedar-14/
