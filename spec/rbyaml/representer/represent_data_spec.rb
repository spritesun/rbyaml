require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "Representer#represent_data" do
  it "should return recursive sequence node when represent recursive array" do
    recursive_array = []; recursive_array[0] = recursive_array
    representer = Representer.new(nil)

    recursive_seq_node = representer.represent_data(recursive_array)

    recursive_seq_node.class.should == SequenceNode
    recursive_seq_node.value[0].should == recursive_seq_node.itself
  end

  it "could return deep recursive array" do
    deep_recursive_array = []; deep_recursive_array[0] = []; deep_recursive_array[0][0] = deep_recursive_array
    representer = Representer.new(nil)

    deep_recursive_seq_node = representer.represent_data(deep_recursive_array)

    deep_recursive_seq_node.class.should == SequenceNode
    deep_recursive_seq_node.value[0].class.should == SequenceNode
    deep_recursive_seq_node.value[0].value[0].should == deep_recursive_seq_node.itself
  end

  it "should return recursive mappingnode when represent recursive map" do
    recursive_map = { }; recursive_map[recursive_map] = recursive_map
    representer = Representer.new(nil)

    recursive_map_node = representer.represent_data(recursive_map)
    recursive_map_node.class.should == MappingNode
    recursive_map_node.value.keys[0].should == recursive_map_node.itself
    recursive_map_node.value.values[0].should == recursive_map_node.itself
  end

end

module RbYAML
  class CollectionNode
    def itself
      self
    end
  end

end
