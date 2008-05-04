# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/common'

describe "YAML.dump" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end
  
  it "converts an object to YAML and write result to io when io provided" do
    File.open($test_file, 'w' ) do |io|
      YAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    YAML.load_file($test_file).should == ['badger', 'elephant', 'tiger']
  end
  
  it "returns a string containing dumped YAML when no io provided" do
    YAML.dump( :locked ) == "--- :locked"
  end  
end
