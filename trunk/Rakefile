require 'rake'
require 'rake/testtask'
require 'rubygems'
require 'spec/rake/spectask'

task :default => [:test, :spec]

Rake::TestTask.new do |task|
  task.libs << "test"
  task.test_files = FileList['test/test_rbyaml.rb']
#  task.warning = true
end

Spec::Rake::SpecTask.new do |task|
  task.libs << "spec"
  task.spec_files = FileList['spec/load_spec.rb']
#  task.warning = true
end
