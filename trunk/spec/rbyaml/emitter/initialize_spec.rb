require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "Emitter#new" do
  it "could initialize without best_indent error" do
    lambda { Emitter.new("", DEFAULTS) }.should_not raise_error
  end
end
