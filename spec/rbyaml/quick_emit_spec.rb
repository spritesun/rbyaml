require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "RbYAML#quick_emit" do
  it "should be able to quick_emit" do
    test_bean = TestBean.new
    test_bean.yaml_emit.should == "--- !ruby/object:TestBean\na: 1\nb: 2\n"
  end
end

class TestBean
  def initialize
    @a = 1
    @b = 2
  end
  def yaml_emit( opts = {} )
    RbYAML.quick_emit( self.object_id, opts ) { |out|
      out.map(taguri, to_yaml_style) { |map|
        instance_variables.sort.each { |iv|
          map.add( iv[1..-1], instance_eval( iv ) )
        }
      }
    }
  end
end
