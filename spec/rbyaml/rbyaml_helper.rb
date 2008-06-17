require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

class SpecMatcher
  def initialize(expected)
    @expected = expected
  end

  def failure_message
    "expected #{@expected.inspect}, got #{@actual.inspect} (using .equal?)"
  end

  def negative_failure_message
    "expected #{@actual.inspect} not to equal #{@expected.inspect} (using .equal?)"
  end

  def description
    "equal #{@expected.inspect}"
  end
end

class LoadAs < SpecMatcher
  def matches?(actual_yaml)
    @actual = RbYAML.load(actual_yaml)
    @actual == @expected
  end
end

# :call-seq:
#   should load_as(expected)
#
# Passes if actual yaml representation load as expected object.
#
# See http://www.ruby-doc.org/core/classes/Object.html#M001057 for more information about equality in Ruby.
#
# == Examples
#
# #   "--- :lock".should load_as(":lock")
def load_as(expected)
  LoadAs.new(expected)
end

class DumpAs < SpecMatcher
  def matches?(actual_yaml)
    @actual = RbYAML.dump(actual_yaml)
    @actual == @expected
  end
end

def dump_as(expected)
  DumpAs.new(expected)
end
