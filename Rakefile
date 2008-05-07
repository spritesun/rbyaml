require 'rake'
require 'rake/testtask'
require 'rubygems'
require 'spec/rake/spectask'

task :default => [:test]

Rake::TestTask.new do |task|
  task.libs << "test"
  task.test_files = FileList['test/test_rbyaml.rb']
#  task.warning = true
end

Spec::Rake::SpecTask.new do |task|
  task.spec_files = FileList['spec/rbyaml/load_spec.rb', 'spec/rbyaml/_load_spec.rb']
  task.spec_files << ['spec/rbyaml/constructor/get_data_spec.rb', 'spec/rbyaml/constructor/construct_document_spec.rb']
#  task.warning = true
end
