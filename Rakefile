desc 'Make vimrc_default'
task :make_default_vimrc do
  require 'yaml'
  require './lib/vimrc_option'
  require './lib/vimrc_creator'

  config = YAML.load_file('./config/config.yml')

  VimFactory::VimrcCreator.new(
    VimFactory::VimrcOption.initial_options,
    "#{config['vimrc_dir']}/vimrc_default"
  ).create
end

desc 'Compile Sass'
task :compile_sass do
  `bundle exec sass ./sass/butterfly.sass ./public/css/butterfly.css`
  `bundle exec sass ./sass/main.sass ./public/css/main.css`
end

desc 'Compile CoffeeScript'
task :compile_coffee_script do
  `coffee -o ./public/js/ -c coffee/`
  `coffee -o ./public/js/ -c coffee/ext/`
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['./app.rb', 'lib/**/*.rb', './Rakefile']
  task.options = ['--debug']
end

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << 'tests'
  t.test_files = FileList['tests/test*.rb']
  t.verbose = true
end
