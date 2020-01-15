# virtualenvwrapper

This is a Puppet module for managing Python virtualenvs using
[Virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/).
Multiple virtualenvs can be created with their own postactivate and deactivate
hooks. This is a useful way to keep multiple development or working
environments neatly separated.

1. [Description](#description)
3. [Usage](#usage)

## Description

If you need to switch between multiple working environments then
virtualenvwrapper, coupled with its support for postactivate and postdeactivate
hooks, allows you to make switching between them quite painless. This module
aims to make the management of those virtualenvs easier in a puppetized
environment. Some of the things you may wish to customize per-environment are:

* Location of eyaml configuration files
* AWS API keys
* Git committer email

Each virtualenv should set these properly and unset them when you deactivate it.

## Usage

Using this module is straightforward. To install virtualenvwrapper with pip3:

    include ::virtualenvwrapper

To create a virtualenv without any postactivate/postdeactivate hooks:
    
    ::virtualenvwrapper::env { 'myenv':
      user                 => 'joe',
    }

To use template-based hooks:

    ::virtualenvwrapper::env { 'myenv':
      user                   => 'joe',
      postactivate_content   => template('profile/myenv_postactivate.erb'),
      postdeactivate_content => template('profile/myenv_postdeactivate.erVb'),

To have postactivate export and postdeactivate unset environment variables of
your choice:

    ::virtualenvwrapper::env { 'myenv':
      user          => 'joe',
      env_variables => { 'foo' => 'bar',
                         'faz' => 'goo', },
    }
