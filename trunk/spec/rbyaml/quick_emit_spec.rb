require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "RbYAML#quick_emit" do
  it "should be able to quick_emit" do
    TestBean.new("sprite", 20, Date.civil(1988, 6, 27)).yaml_emit.should == "--- !ruby/object:TestBean\nage: 20\nborn: 1988-06-27\nname: sprite\n"
  end
end

class TestBean
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
