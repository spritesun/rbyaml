require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |task|
  task.libs << "test"
  task.test_files = FileList['test/test_rbyaml.rb']
  task.verbose = true
  task.warning = true
end
