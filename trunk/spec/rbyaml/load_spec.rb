# Copyright (c) 2007, Evan Phoenix.
# Distributed under BSD License.
# Modified by Long Sun <spritesun@gmail.com>.

require 'spec_helper'

describe "RbYAML#load" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end
  
  it "should return a document from current io stream when io provided" do
    File.open($test_file, 'w') do |io|
      RbYAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    File.open($test_file) { |yf| RbYAML.load( yf ) }.should == ['badger', 'elephant', 'tiger']
  end
  
  it "should return a symbol when accepting a string include symbol" do
#    RbYAML.load( "--- :locked" ).should == :locked
  end  
end