require 'set'
require 'date'

require 'rbyaml/error'
require 'rbyaml/nodes'

module RbYAML
  class RepresenterError < YAMLError
  end

  class BaseRepresenter
    def initialize(serializer, opts={})
      @serializer = serializer
      @default_style = opts[:UseDouble] ? '"' : (opts[:UseSingle] ? "'" : nil)
      @represented_objects = {}
      @flow_default_style = nil
    end

    def represent(data)
      node = represent_data(data)
      @serializer.serialize(node)
      represented_objects = {}
    end

    def represent_data(data)
      if ignore_aliases(data)
        alias_key = nil
      else
        alias_key = data.object_id
      end

      if !alias_key.nil?
        if @represented_objects.include?(alias_key)
          node = @represented_objects[alias_key]
          node ||= RecursiveNode.new
          return node
        end
        @represented_objects[alias_key] = nil
      end
      node = data.to_yaml_node(self)
      @represented_objects[alias_key] = node if !alias_key.nil?
      transform_recursive_node(node)
      node
    end

    def transform_recursive_node(itself)
      if itself.instance_of?(SequenceNode)
        itself.value.each_index do |node_item_index|
          itself.value[node_item_index] = itself if itself.value[node_item_index].instance_of?(RecursiveNode)
        end
      elsif itself.instance_of?(MappingNode)
        itself.value.each do |key, value|
          if key.instance_of?(RecursiveNode)
            itself.value[itself] = value
            itself.value.delete(key)
            key = itself
          end
          if value.instance_of?(RecursiveNode)
            itself.value[key] = itself
          end
        end
      end
    end

    def scalar(tag, value, style=nil)
      represent_scalar(tag,value,style)
    end

    def represent_scalar(tag, value, style=nil)
      style ||= @default_style
      ScalarNode.new(tag,value,style)
    end

    def seq(tag, sequence, flow_style=nil)
      represent_sequence(tag,sequence,flow_style)
    end

    def represent_sequence(tag, sequence, flow_style=nil)
      best_style = false
      value = sequence.map {|item|
        node_item = represent_data(item)
        best_style = false if !node_item.__is_scalar && !node_item.flow_style
        node_item
      }
      flow_style ||= (@flow_default_style || best_style)
      SequenceNode.new(tag, value, flow_style)
    end

    def map(tag, *args)
      if args.length == 1
        mapping = {}
        def mapping.add(key, value)
          self[key] = value
        end
        yield mapping
        flow_style = args.first
      elsif args.length == 2
        mapping, flow_style = args
      else
        raise ArgumentError, "wrong number of arguments (#{args.length})"
      end

      represent_mapping(tag,mapping,flow_style)
    end

    def represent_mapping(tag, mapping, flow_style=nil)
      best_style = false
      if mapping.respond_to?(:keys)
        value = {}
        for item_key,item_value in mapping
          node_key = represent_data(item_key)
          node_value = represent_data(item_value)
          best_style = false if !node_key.__is_scalar && !node_key.flow_style
          best_style = false if !node_value.__is_scalar && !node_value.flow_style
          value[node_key] = node_value
        end
      else
        value = []
        for item_key, item_value in mapping
          node_key = represent_data(item_key)
          node_value = represent_data(item_value)
          best_style = false if !node_key.__is_scalar && !node_key.flow_style
          best_style = false if !node_value.__is_scalar && !node_value.flow_style
          value << [node_key, node_value]
        end
      end
      flow_style ||= (@flow_default_style || best_style)
      MappingNode.new(tag, value, flow_style)
    end

    def ignore_aliases(data)
      false
    end
  end

  class SafeRepresenter < BaseRepresenter
    def ignore_aliases(data)
      data.nil? || data.__is_str || TrueClass === data || FalseClass === data || data.__is_int || Float === data
    end
  end

  class Representer < SafeRepresenter
  end
end
