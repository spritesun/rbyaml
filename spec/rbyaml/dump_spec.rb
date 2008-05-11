# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML.dump" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end
  
  it "converts an object to RbYAML and write result to io when io provided" do
    File.open($test_file, 'w' ) do |io|
      RbYAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    RbYAML.load_file($test_file).should == ['badger', 'elephant', 'tiger']
  end
  
  it "returns a string containing dumped RbYAML when no io provided" do
    RbYAML.dump( :locked ) == "--- :locked"
  end  
end
