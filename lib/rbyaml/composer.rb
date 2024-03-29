require 'rbyaml/error'
require 'rbyaml/events'
require 'rbyaml/nodes'

module RbYAML
  class ComposerError < YAMLError
  end

  class Composer
    def initialize(parser,resolver)
      @parser = parser
      @resolver = resolver
      @anchors = {}
    end

    def check_node
      !@parser.peek_event.__is_stream_end
    end

    def get_node
      compose_document if check_node
    end

    def each_node
      yield compose_document while check_node
    end

    def compose_document
      # Drop the STREAM-START event.
      @parser.get_event if @parser.peek_event.__is_stream_start
      if @parser.peek_event.__is_stream_end
        return ScalarNode.new("tag:yaml.org,2002:null", "")
      end
      # Drop the DOCUMENT-START event.
      @parser.get_event
      # Compose the root node.
      node = compose_node(nil,nil)
      # Drop the DOCUMENT-END event.
      @parser.get_event
      @anchors = {}
      node
    end

    def compose_node(parent,index)
      if @parser.peek_event.__is_alias
        event = @parser.get_event
        anchor = event.anchor
        raise ComposerError.new(nil, "found undefined alias #{anchor}") if !@anchors.include?(anchor)
        return @anchors[anchor]
      end
      event = @parser.peek_event
      anchor = event.anchor if event.__is_node
#       unless anchor.nil?
#         if @anchors.include?(anchor)
#           raise ComposerError.new("found duplicate anchor #{anchor}; first occurence","second occurence")
#         end
#       end
      @resolver.descend_resolver(parent,index)
      if @parser.peek_event.__is_scalar
        node = compose_scalar_node(anchor)
      elsif @parser.peek_event.__is_sequence_start
        node = compose_sequence_node(anchor)
      elsif @parser.peek_event.__is_mapping_start
        node = compose_mapping_node(anchor)
      end
      @resolver.ascend_resolver
      node
    end

    def compose_scalar_node(anchor)
      event = @parser.get_event
      tag = event.tag
      tag = @resolver.resolve(ScalarNode,event.value,event.implicit) if tag.nil? || tag == "!"
      node = ScalarNode.new(tag, event.value,event.style)
      @anchors[anchor] = node if !anchor.nil?
      node
    end

    def compose_sequence_node(anchor)
      start_event = @parser.get_event
      tag = start_event.tag
      tag = @resolver.resolve(SequenceNode,nil,start_event.implicit) if tag.nil? || tag == "!"
      node = SequenceNode.new(tag,[],start_event.flow_style)
      @anchors[anchor] = node if !anchor.nil?
      index = 0
      while !@parser.peek_event.__is_sequence_end
        node.value << compose_node(node,index)
        index += 1
      end
      @parser.get_event
      node
    end

    def compose_mapping_node(anchor)
      start_event = @parser.get_event
      tag = start_event.tag
      tag = @resolver.resolve(MappingNode,nil,start_event.implicit) if tag.nil? || tag == "!"
      node = MappingNode.new(tag, {},start_event.flow_style)
      @anchors[anchor] = node if !anchor.nil?
      while !@parser.peek_event.__is_mapping_end
        key_event = @parser.peek_event
        item_key = compose_node(node,nil)

        node.value.each do |key, value|
          if key.tag == item_key.tag && key.value == item_key.value
            # According to YAML1.1 Specification, section 3.2.1.3, it should raise error, but we give a friendly processing method currently.
            # raise ComposerError.new("while composing a mapping","found duplicate key")
            node.value.delete(key)
          end
        end

        item_value = compose_node(node,item_key)
        node.value[item_key] = item_value
      end
      @parser.get_event
      node
    end
  end
end
