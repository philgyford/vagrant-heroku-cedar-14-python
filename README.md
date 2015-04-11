A work in progress. Trying to make a Vagrant box for python/Django development, mimicking a Heroku cedar-14 dyno.

So far:

* Ubuntu 14.04
* PosgreSQL 9.4
* python 2.7.6
* Requirements for Pillow
* pip, virtualenv, virtualenvwrapper

To do:

* Foreman?
* Nginx?
* Other things?

It will make a new virtualenv and install any requirements specified in a `requirements.txt` file.

Useful:

* https://devcenter.heroku.com/articles/cedar-ubuntu-packages
* https://github.com/ejholmes/vagrant-heroku/
* https://github.com/kiere/vagrant-heroku-cedar-14/
