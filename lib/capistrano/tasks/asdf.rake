ASDF_USER_PATH = "~/.asdf"
ASDF_DEFAULT_TOOLS = %w{ruby nodejs}
# Ruby related bins
ASDF_DEFAULT_RUBY_BINS = %w{rake gem bundle ruby rails}
# Nodejs related bin
ASDF_DEFAULT_NODEJS_BINS = %w{node npm yarn}

ASDF_DEFAULT_WRAPPER_TEMPLATES = <<~WRAPPER
  #!/usr/bin/env bash

  . @@ASDF_USER_PATH@@/asdf.sh
  exec "$@"
WRAPPER

namespace :asdf do
  desc "Upload ASDF wrapper to the target host"
  task :upload_wrapper do
    on roles(fetch(:asdf_roles, :all)) do
      wrapper_content = ASDF_DEFAULT_WRAPPER_TEMPLATES.gsub('@@ASDF_USER_PATH@@', fetch(:asdf_path))
      need_to_upload_wrapper = true
      # Check if the wrapper already exists
      if test("[ -f #{fetch(:asdf_wrapper_path)} ]")
        # Check if md5sum is available on the target host
        if test("which md5sum")
        else
          info "md5sum is not available on the target host, we can't check the wrapper integrity"
          need_to_upload_wrapper = false
        end
        # Check if the wrapper is the same as the one we want to upload using a md5 checksum
        if capture("md5sum #{fetch(:asdf_wrapper_path)}").split.first == Digest::MD5.hexdigest(wrapper_content)
          need_to_upload_wrapper = false
        else
          info "ASDF wrapper already exists on the target host but is different from the one we want to upload"
        end
      end
      if need_to_upload_wrapper
        upload! StringIO.new(wrapper_content), "#{fetch(:asdf_wrapper_path)}"
        execute("chmod +x #{fetch(:asdf_wrapper_path)}")
      else
        info "ASDF wrapper already exists on the target host"
      end
    end
  end

  desc "Prints the ASDF tools versions on the target host"
  task :check do
    on roles(fetch(:asdf_roles, :all)) do
      execute("#{fetch(:asdf_wrapper_path)} asdf current")
    end
  end

  desc "Install ASDF tools versions based on the .tool-versions of your project"
  task :install do
    on roles(fetch(:asdf_roles, :all)) do
      execute("#{fetch(:asdf_wrapper_path)} asdf install")
    end
  end

  desc "Add ASDF plugins specified in :asdf_tools"
  task :add_plugins do
    on roles(fetch(:asdf_roles, :all)) do
      already_installed_plugins = capture("#{fetch(:asdf_wrapper_path)} asdf plugin list")&.split
      fetch(:asdf_tools)&.each do |asdf_tool|
        if already_installed_plugins.include?(asdf_tool)
          info "#{asdf_tool} Already installed"
        else
          execute("#{fetch(:asdf_wrapper_path)} asdf plugin add #{asdf_tool}")
        end
      end
    end
  end

  task :map_ruby_bins do
    if fetch(:asdf_tools).include?('ruby')
      fetch(:asdf_map_ruby_bins).each do |mapped_command|
        SSHKit.config.command_map.prefix[mapped_command.to_sym].unshift("#{fetch(:asdf_wrapper_path)}")
      end
    end
  end

  task :map_nodejs_bins do
    if fetch(:asdf_tools).include?('nodejs')
      fetch(:asdf_map_nodejs_bins).each do |mapped_command|
        SSHKit.config.command_map.prefix[mapped_command.to_sym].unshift("#{fetch(:asdf_wrapper_path)}")
      end
    end
  end

end

before 'asdf:install', 'asdf:add_plugins'
after 'deploy:check', 'asdf:check'
before 'asdf:check', 'asdf:upload_wrapper'

Capistrano::DSL.stages.each do |stage|
  after stage, 'asdf:map_ruby_bins'
  after stage, 'asdf:map_nodejs_bins'
end

namespace :load do
  task :defaults do
    set :asdf_path, -> {
      asdf_path = fetch(:asdf_custom_path)
      asdf_path ||= ASDF_USER_PATH
    }
    set :asdf_wrapper_path, -> {
      fetch(:asdf_custom_wrapper_path) || "#{shared_path}/asdf-wrapper"
    }

    set :asdf_tools, fetch(:asdf_tools, ASDF_DEFAULT_TOOLS)

    set :asdf_map_ruby_bins, fetch(:asdf_map_ruby_bins, ASDF_DEFAULT_RUBY_BINS)
    set :asdf_map_nodejs_bins, fetch(:asdf_map_nodejs_bins, ASDF_DEFAULT_NODEJS_BINS)
  end
end
