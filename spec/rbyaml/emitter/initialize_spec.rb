require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "RbYAML#Emitter" do
  it "could initialize without best_indent error" do
    lambda { RbYAML::Emitter.new("", RbYAML::DEFAULTS) }.should_not raise_error
  end
end
