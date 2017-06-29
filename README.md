# Vagrant Heroku cedar-14 box for Python and Django

A Vagrant box for python/Django development, mimicking a Heroku cedar-14 dyno.

* Ubuntu 14.04 (ubuntu/trusty64)
* PostgreSQL 9.6
* Python 2.7 or 3.6
* pip, virtualenv, virtualenvwrapper
* Requirements for the python image processing module Pillow
* foreman (optional, and sometimes problematic; see below)
* GeoDjango requirements (optionally)

If a `requirements.txt` file is found, modules in it will be installed into the virtualenv.

When you ssh into the VM the virtualenv will automatically be activated.

If a `Procfile` is found, foreman will be started.

The project directory (containing the `Vagrantfile`) will be availble in the VM at `/vagrant/`.

If there's a `manage.py` file in the root of the project, it will run Django's `migrate` and `collectstatic` commands.


## Running it

1. Install [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

2. In your project, make a `config/` directory, if it doesn't already have one.

3. Make a copy of `config/vagrant.template.yml` and put it at `config/vagrant.yml` in *your* project.

4. If you have a Procfile, and therefore want foreman to run, you *must* change the Django `settings_module` in `config/vagrant.yml` to whatever you want the `DJANGO_SETTINGS_MODULE` environment variable in the virtual machine to be. Feel free to change any of the other config options if appropriate.

    You can also change the name of the Procfile foreman should use in `config/vagrant.yml`, in case you want to use a different one in Vagrant versus live (see below).

5. Either copy, move or symlink `Vagrantfile` and the `config/vagrant/` directory into your Django project. So it will be something like:

        config/
            vagrant/        # a copy or symlink
            vagrant.yml
        myproject/
            ...
		manage.py
        Procfile
        requirements.txt
        runtime.txt         # optional, see below
        Vagrantfile         # a copy or symlink

    This will vary slightly depending on your Django project's layout.

6. Run `vagrant up` from the same directory that the copy/symlink of `Vagrantfile` is in.

7. Go to [http://localhost:5000/](http://localhost:5000) in your browser.

If you change or update any of the Vagrant stuff, then do `vagrant provision` to have it run through and update the box with changes.

### Subsequently

If you `vagrant halt` the box, you'll need to do `vagrant up --provision` to get everything running again. Just doing `vagrant up` won't currently start foreman etc.


## Foreman or the Django development server?

By default foreman sends output to stdout and stderr. This prevents Vagrant from exiting nicely, even though we run foreman as `foreman .. &`. To ensure a smooth exit from foreman, and to be able to see its output in future, you should send the output of processes in your Procfile to a file. eg:

    web: gunicorn --reload --log-level debug myproject.wsgi > /vagrant/gunicorn.log 2>&1

Then you can just `tail -f /vagrant/gunicorn.log` to see its output. For this reason you might want to use a different Procfile for use in Vagrant than you do with your live server (use the setting in `config/vagrant.yml` to specify the filename).

Also note: We use the `--reload` option with gunicorn so that it reloads when code changes. Otherwise you'll never see changes when you make them!

**However:** This still [seems to get stuck](http://stackoverflow.com/questions/38208840/restart-gunicorn-run-with-foreman-on-error) sometimes, with gunicorn's log showing "Worker failed to boot". To avoid using foreman at all change the `procfile` setting in your `config/vagrant.yml` file to something that doesn't exist (eg, `'false'`). Then you can run the Django dev server manually:

    $ vagrant ssh
    vagrant$ /vagrant/manage.py runserver 0.0.0.0:5000


## Python versions

By default the virtualenv will use python 2.7.

To specify python 3.5 [Heroku requires you](https://devcenter.heroku.com/articles/python-runtimes) to place a `runtime.txt` file in your repository's root containing one line:

    python-3.5.2

When setting up the Vagrant box, if this file is present, and contains `python-3.5*`, then python 3.5 will be installed and used for the virtualenv.


## GeoDjango

If you want to use GeoDjango, set the ``use_geodjango`` variable in your `config/vagrant.yml` file to the string ``true``:

    use_geodjango: 'true'

This will install the requirements for using GeoDjango: GEOS, PROJ.4, GDAL, PostGIS.

### Note

The install script should do this, but I had an occasion when I was getting this error while running Django migrations:

	django.db.utils.ProgrammingError: permission denied to create extension "postgis"

So I had to do this (replace `DB_NAME` with your database name):
	
	$ vagrant ssh
	vagrant$ sudo -u postgres psql DB_NAME
	=# CREATE EXTENSION postgis;
	=# \q


## Database

To change the version of Postgres (and PostGIS, if you're using GeoDjango), edit the variable(s) in `config/vagrant/postgresql_setup.sh`.

The process above will set up a postgres database and user, but not populate the database. Database name, username and password are set in `config/vagrant.yml`.

If you have a `pg_dump` dump file, put it in the same directory as your Django project and then:

    $ vagrant ssh
    vagrant$ cd /vagrant
    vagrant$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U your_pg_username -d your_db_name your-dump-name.dump

You'll be prompted for the postgres user's password, and then it should import.


## Virtualenvwrapper

If you want to use virtualenvwrapper's [user-defined hooks](http://virtualenvwrapper.readthedocs.org/en/latest/scripts.html#scripts) then create a directory at `config/virtualenvwrapper/vagrant/` containing them. For example, continuing our example structure above:

        config/
            vagrant/        # a copy or symlink
            vagrant.yml
            virtualenvwrapper/
                vagrant/
                    postactivate
                    postdeactivate
                    preactivate
        ...

If this directory is present, the `VIRTUALENVWRAPPER_HOOK_DIR` environment variable will be set, and these files will be used instead of the defaults.

So, to set environment variables for your virtualenv you might add something like this to your `postactivate` file:

    #!/bin/bash
    # This hook is run after this virtualenv is activated.

    export MY_ENVIRONMENT_VARIABLE=hello-there

These files are only created on initial set-up, so to change their contents subsequently, do it manually. They can be found in the vagrant box at `/home/vagrant/.virtualenvs/your-venv-name/bin/`.


## Potential problems

If you try to access your Django site in a browser but get a "Peer authentication failed for user" error, then ensure you've set the `HOST` value in your Django settings file to `localhost` or (*for development only*) `"*"`. An empty string will not work.


## Useful / Inspired by:

* https://github.com/kiere/vagrant-heroku-cedar-14/
* https://github.com/ejholmes/vagrant-heroku/
* https://github.com/torchbox/vagrant-django-base/
* https://github.com/torchbox/vagrant-django-template
* https://github.com/jackdb/pg-app-dev-vm/
* https://github.com/maigfrga/django-vagrant-chef/
* https://devcenter.heroku.com/articles/cedar-ubuntu-packages


## Credits

* [Phil Gyford](https://github.com/philgyford) - Initial creation
* [Steven Day](https://github.com/stevenday) - v1.1 updates and fixes

