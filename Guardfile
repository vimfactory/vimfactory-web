coffeescript_options = {
  input: 'coffee',
  output: 'public/js',
  patterns: [%r{^coffee/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end

guard 'sass', input: 'sass', output: 'public/css'

guard :rubocop do
  watch(/%r{.+\.rb$}/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard :minitest, test_folders: 'tests', test_file_patterns: '*.rb' do
  watch(%r{^tests/(.*)\/?test_(.*)\.rb$}) { 'tests' }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { 'tests' }
end
