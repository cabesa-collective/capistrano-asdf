## 1.1.0

Upload and use an ASDF wrapper to fully load ASDF environnement before executing commands.
The wrapper is generated in `<shared_path>/asdf-wrapper` by default, but can be generated elsewhere by setting `:asdf_custom_wrapper_path` capistrano variable.

## 1.0.0

Add asdf:install and asdf:add_plugins tasks

## 0.0.3

Add some configuration options:

    set :asdf_custom_path, '~/.my_asdf_installation_path'  # only needed if not '~/.asdf'
    set :asdf_tools, %w{ ruby }                            # defaults to %{ ruby nodejs }
    set :asdf_map_ruby_bins, %w{ bundle gem }              # defaults to %w{ rake gem bundle ruby rails }
    set :asdf_map_nodejs_bins, %w{ node npm }              # defaults to %w{ node npm yarn }

## 0.0.2

Basic working tasks
