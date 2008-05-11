# Copyright (c) 2007, Evan Phoenix
# Distributed under BSD License
# Modified by Long Sun

require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "RbYAML.load_file" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end
  
  it "returns a hash" do
    File.open($test_file,'w' ){|io| RbYAML.dump( {"bar"=>2, "car"=>1}, io ) }
    RbYAML.load_file($test_file).should == {"bar"=>2, "car"=>1}
  end
end
