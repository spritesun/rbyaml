require 'rbyaml/ypath'

module RbYAML
  Node = Struct.new(:tag, :value)
  class Node
    def hash
      object_id
    end

    def to_s
      "#{self.class.name}(tag=#{tag}, value=#{value})"
    end

    def <=>(other)
        self.value <=> other.value
    end

    def transform
      Constructor.new(nil).construct_document(self)
    end

    def __is_scalar; false; end
    def __is_collection; false; end
    def __is_sequence; false; end
    def __is_mapping; false; end
    def __is_recursive
      false
    end
  end

  class ScalarNode < Node
    def tid
      "scalar"
    end

    attr_accessor :style

    def initialize(tag,value,style=nil)
      super(tag,value)
      @style = style
    end
    def __is_scalar; true; end
  end

  class CollectionNode < Node
    attr_accessor :flow_style

    def initialize(tag, value,flow_style=nil)
      super(tag,value)
      @flow_style = flow_style
    end
    def __is_collection; true; end
  end

  class SequenceNode < CollectionNode
    def tid
      "sequence"
    end
    def __is_sequence; true; end
  end

  class MappingNode < CollectionNode
    def tid
      "mapping"
    end
    def __is_mapping; true; end
  end

  class RecursiveNode < CollectionNode
    def initialize
    end
    def __is_recursive
      true
    end
  end
end

