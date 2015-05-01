desc 'Make vimr_default'
task :make_default_vimrc do
  require 'yaml'
  require './lib/vimrc_option'
  require './lib/vimrc_creator'

  config = YAML.load_file('./config/config.yml')
  static_options  = VimFactory::VimrcOption::STATIC_OPTIONS
  default_options = VimFactory::VimrcOption::DEFAULT_OPTIONS.merge(static_options)

  vimrc_creator = VimFactory::VimrcCreator.new(default_options,"#{config["vimrc_dir"]}/vimrc_default")
  vimrc_creator.create
end
