# Capistrano::ASDF

ASDF support for Capistrano v3:

## Notes

**If you use this integration with capistrano-rails, please ensure that you have `capistrano-bundler >= 1.1.0`.**

## Installation

Add this line to your application's Gemfile:

    # Gemfile
    gem 'capistrano', '~> 3.0'
    gem 'capistrano-asdf'

And then execute:

    $ bundle install

## Usage

Require in Capfile to use the default task:

    # Capfile
    require 'capistrano/asdf'

And you should be good to go!

## Configuration

There is no configuration yet.
Everything *should work* for a basic ASDF setup *out of the box*.
However we strongly encourage you to use the .tool-versions for proper tool version selection.

## Restrictions

Capistrano can't use ASDF to install rubies, nodes or other tools yet.
So on the servers you are deploying to, you will have to manually use ASDF to install the
proper rubies, nodes or other tools.

## How it works

This gem adds a new task `asdf:hook` before `deploy` task.
It loads the ASDF tools environment for capistrano when it wants to run
some tools related programs like `rake`, `gem`, `bundle`, `node`, `npm` ...

## Check your configuration

If you want to check your configuration you can use the `asdf:check` task to
get information about the ASDF version and ruby/nodejs tools which would be used for
deployment.

    $ cap production asdf:check

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
