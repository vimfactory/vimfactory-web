desc 'Make vimr_default'
task :make_default_vimrc do
  require 'yaml'
  require './lib/vimrc_option'
  require './lib/vimrc_creator'

  config = YAML.load_file('./config/config.yml')
  fixed_options = VimFactory::VimrcOption.fixed_options
  default_options = VimFactory::VimrcOption.initial_options.merge(fixed_options)

  vimrc_creator = VimFactory::VimrcCreator.new(
    default_options,
    "#{config['vimrc_dir']}/vimrc_default"
  )
  vimrc_creator.create
end
