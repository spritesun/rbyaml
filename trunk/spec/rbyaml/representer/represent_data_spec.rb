require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "RbYAML::Representer#represent_data" do
  it "should return recursive sequence node when represent recursive array" do
    recursive_array = []
    recursive_array[0] = recursive_array
    representer = RbYAML::Representer.new(nil)

    recursive_seq_node = representer.represent_data(recursive_array)

    recursive_seq_node.class.should == RbYAML::SequenceNode
    recursive_seq_node.value[0].should == recursive_seq_node.itself
  end

  it "could return deep recursive array" do
    deep_recursive_array = []
    deep_recursive_array[0] = []
    deep_recursive_array[0][0] = deep_recursive_array
    representer = RbYAML::Representer.new(nil)

    deep_recursive_seq_node = representer.represent_data(deep_recursive_array)

    deep_recursive_seq_node.class.should == RbYAML::SequenceNode
    deep_recursive_seq_node.value[0].class.should == RbYAML::SequenceNode
    deep_recursive_seq_node.value[0].value[0].should == deep_recursive_seq_node.itself
  end

  it "should return recursive mappingnode when represent recursive map" do
    pending
  end

end

module RbYAML
  class SequenceNode
    def itself
      self
    end
  end
end
