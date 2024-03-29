require 'rbyaml/error'
require 'rbyaml/events'
require 'rbyaml/nodes'

module RbYAML
  class SerializerError < YAMLError
  end

  class Serializer
    def initialize(emitter, resolver, opts={})
      @emitter = emitter
      @resolver = resolver
      @options = opts
      @use_explicit_start = opts[:ExplicitStart]
      @use_explicit_end = opts[:ExplicitEnd]
      @explicit_type = opts[:ExplicitTypes]
      # Currently, :Version doesn't make any sense
      @use_version = opts[:UseVersion] && $global_yaml_version
      @use_tags = opts[:UseHeader]
      @anchor_template = opts[:AnchorFormat] || "id%03d"
      @serialized_nodes = {}
      @anchors = {}
      @last_anchor_id = 0
      @closed = nil
    end

    def open
      if @closed.nil?
        @emitter.emit(StreamStartEvent.new)
        @closed = false
      elsif @closed
        raise SerializerError.new("serializer is closed")
      else
        raise SerializerError.new("serializer is already opened")
      end
    end

    def close
      if @closed.nil?
        raise SerializerError.new("serializer is not opened")
      elsif !@closed
        @emitter.emit(StreamEndEvent.new)
        @closed = true
      end
    end

    def serialize(node)
      if @closed.nil?
        raise SerializerError.new("serializer is not opened")
      elsif @closed
        raise SerializerError.new("serializer is closed")
      end
      @emitter.emit(DocumentStartEvent.new(@use_explicit_start,@use_version,nil))
      anchor_node(node)
      serialize_node(node,nil,nil)
      @emitter.emit(DocumentEndEvent.new(@use_explicit_end))
      @serialized_nodes = {}
      @anchors = {}
      @last_alias_id = 0
    end

    def anchor_node(node)
      if @anchors.include?(node)
        @anchors[node] ||= generate_anchor(node)
      else
        @anchors[node] = nil
        if SequenceNode === node
          for item in node.value
            anchor_node(item)
          end
        elsif MappingNode === node
          for key,val in node.value
            anchor_node(key)
            anchor_node(val)
          end
        end
      end
    end

    def generate_anchor(node)
      @last_anchor_id += 1
      @anchor_template % @last_anchor_id
    end

    def serialize_node(node,parent,index)
      talias = @anchors[node]
      if @serialized_nodes.include?(node)
        @emitter.emit(AliasEvent.new(talias))
      else
        @serialized_nodes[node] = true
        @resolver.descend_resolver(parent, index)
        if ScalarNode === node
          detected_tag = @resolver.resolve(ScalarNode, node.value, [true,false])
          default_tag = @resolver.resolve(ScalarNode, node.value, [false,true])
          if @explicit_type
            implicit = false, false
          else
            implicit = (node.tag == detected_tag), (node.tag == default_tag)
          end
          @emitter.emit(ScalarEvent.new(talias, node.tag, implicit, node.value,node.style))
        elsif SequenceNode === node
          implicit = !@explicit_type && (node.tag == @resolver.resolve(SequenceNode, node.value, true))
          @emitter.emit(SequenceStartEvent.new(talias, node.tag, implicit,node.flow_style))
          index = 0
          for item in node.value
            serialize_node(item,node,index)
            index += 1
          end
          @emitter.emit(SequenceEndEvent.new)
        elsif MappingNode === node
          implicit = !@explicit_type && (node.tag == @resolver.resolve(MappingNode, node.value, true))
          @emitter.emit(MappingStartEvent.new(talias, node.tag, implicit,node.flow_style))
          for key, value in node.value.sort
            serialize_node(key,node,nil)
            serialize_node(value,node,key)
          end
          @emitter.emit(MappingEndEvent.new)
        end
      end
    end
  end
end

