# Vagrant Heroku cedar-14 box for Python and Django

A Vagrant box for python/Django development, mimicking a Heroku cedar-14 dyno.

* Ubuntu 14.04 (ubuntu/trusty64)
* PostgreSQL 9.4
* python 2.7.6
* pip, virtualenv, virtualenvwrapper
* Requirements for the python image processing module Pillow
* foreman

If a `requirements.txt` file is found, modules in it will be installed into the virtualenv.

When you ssh into the VM the virtualenv will automatically be activated.

If a `Procfile` is found, foreman will be started.

The project directory (containing the `Vagrantfile`) will be availble in the VM at `/vagrant/`.


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
            manage.py
            my_app/
                ...
            ...
        Procfile
        requirements.txt
        Vagrantfile            # a copy or symlink

    This will vary slightly depending on your Django project's layout.

6. Run `vagrant up` from the same directory that the copy/symlink of `Vagrantfile` is in.

7. Go to http://localhost:5000/ in your browser.

If you change or update any of the Vagrant stuff, then do `vagrant provision` to have it run through and update the box with changes.


## Foreman

By default foreman sends output to stdout and stderr. This prevents Vagrant from exiting nicely, even though we run foreman as `foreman .. &`. To ensure a smooth exit from foreman, and to be able to see its output in future, you should send the output of processes in your Procfile to a file. eg:

    web: gunicorn myproject.wsgi > /vagrant/gunicorn.log 2>&1

Then you can just `tail -f /vagrant/gunicorn.log` to see its output. For this reason you might want to use a different Procfile for use in Vagrant than you do with your live server (use the setting in `config/vagrant.yml` to specify the filename).
    

## Database

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
                    preactivate
                    postdeactivate
        ...

If this directory is present, the `VIRTUALENVWRAPPER_HOOK_DIR` environment variable will be set, and these files will be used instead of the defaults.


## Potential problems

If you try to access your Django site in a browser but get a "Peer authentication failed for user" error, then ensure you've set the `HOST` value in your Django settings file to `localhost`. An empty string will not work.


## Useful / Inspired by:

* https://github.com/kiere/vagrant-heroku-cedar-14/
* https://github.com/ejholmes/vagrant-heroku/
* https://github.com/torchbox/vagrant-django-base/
* https://github.com/torchbox/vagrant-django-template
* https://github.com/jackdb/pg-app-dev-vm/
* https://github.com/maigfrga/django-vagrant-chef/
* https://devcenter.heroku.com/articles/cedar-ubuntu-packages

