ASDF_USER_PATH = "~/.asdf"

namespace :asdf do
  
  task :map_ruby_bins do
    fetch(:asdf_map_ruby_bins).each do |mapped_command|
      SSHKit.config.command_map.prefix[mapped_command.to_sym].unshift("source $#{fetch(:asdf_path)}/asdf.sh;")
    end
  end

  task :map_nodejs_bins do
    fetch(:asdf_map_nodejs_bins).each do |mapped_command|
      SSHKit.config.command_map.prefix[mapped_command.to_sym].unshift("source $#{fetch(:asdf_path)}/asdf.sh;")
    end
    fetch(:asdf_map_nodejs_npm_bins).each do |mapped_command|
      SSHKit.config.command_map.prefix[mapped_command.to_sym].unshift("source $#{fetch(:asdf_path)}/asdf.sh;")
    end
  end
  
end

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

    set :asdf_map_ruby_bins, %w{rake gem bundle ruby rails}
    set :asdf_map_nodejs_bins, %w{node npm}
    set :asdf_map_nodejs_npm_bins, %w{yarn}
  end
end
