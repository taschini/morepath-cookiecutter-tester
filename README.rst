Testing morepath-cookiecutter
=============================

This project provides a setup for testing `morepath-cookiecutter`_, a
Cookiecutter template for Morepath.

.. _morepath-cookiecutter: https://github.com/morepath/morepath-cookiecutter

.. highlight:: console

Getting started
---------------

Clone the repository and initialize all submodules::

  $ git clone --recursive git@github.com:taschini/morepath-cookiecutter-tester.git
  $ cd morepath-cookiecutter-tester

Create a new virtual environment and install the requirements::

  $ virtualenv --no-site-packages env
  $ ./env/bin/pip install -r requirements.txt
  $ source ./env/bin/activate

To run the tests simply type::

  $ make

The tests use the remaining sections of this document as a script, so that you
can immediately see what is being tested.

If you want, you can also go through each step by hand. To do so you just need
to set the ``TESTDIR`` variable to the project directory and switch to an empty
directory::

  $ export TESTDIR=`pwd`
  $ cd `mktemp -d testing.XXXXXX`


Create a new project
--------------------

Set up a new project::

   $ cookiecutter ${TESTDIR}/morepath-cookiecutter <<EOF
   > helloworld
   > A RESTful application to greet the world.
   > 1
   > John Doe
   > john.doe@example.com
   > EOF
   package_name [helloworld]: description [A morepath helloworld application]: Select goal:
   1 - A RESTful application
   2 - A traditional web application
   Choose from 1, 2 [1]: author []: author_email []:  (no-eol)

These are the files that have been created::

   $ tree helloworld
   helloworld
   |-- MANIFEST.in
   |-- README.rst
   |-- helloworld
   |   |-- __init__.py
   |   |-- __main__.py
   |   |-- app.py
   |   |-- model.py
   |   |-- path.py
   |   |-- tests
   |   |   `-- test_app.py
   |   `-- view.py
   |-- setup.cfg
   `-- setup.py
   
   2 directories, 11 files

This the generated readme file::

   $ cat helloworld/README.rst
   Helloworld
   ==========
   
   A RESTful application to greet the world.


Testing the functionality of the project
----------------------------------------

Create a virtual environment and setup the project in there::

   $ virtualenv -q --no-site-packages env
   $ ./env/bin/pip install -qe './helloworld[test]'

Verify the project metadata::

   $ cat helloworld/helloworld.egg-info/PKG-INFO
   Metadata-Version: 1.1
   Name: helloworld
   Version: 0.0.0
   Summary: A RESTful application to greet the world.
   Home-page: UNKNOWN
   Author: John Doe
   Author-email: john.doe@example.com
   License: UNKNOWN
   Description: UNKNOWN
   Platform: any
   Classifier: Intended Audience :: Developers
   Classifier: Environment :: Web Environment
   Classifier: Topic :: Internet :: WWW/HTTP :: WSGI
   Classifier: Programming Language :: Python :: 2.7
   Classifier: Programming Language :: Python :: 3.4

Run the tests::

   $ ./env/bin/py.test -q helloworld
   .
   1 passed in .* seconds (re)

Verify PEP8 compliance::

   $ flake8 helloworld

Run the app, query the app, and close the app::

   $ ( ./env/bin/run-app & server=${!};
   > sleep 1;
   > curl -sSw '\n' http://127.0.0.1:5000;
   > kill $server )
   127.0.0.1 - - \[[^]]+\] "GET / HTTP/1.1" 200 147 (re)
   {"greetings": [{"@id": "http://127.0.0.1:5000/greeting/mundo", "name": "mundo"}, {"@id": "http://127.0.0.1:5000/greeting/world", "name": "world"}]}

