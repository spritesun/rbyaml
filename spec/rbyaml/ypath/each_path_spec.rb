require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe "YPath#each_path" do

  it "could parse path" do
    expected = [ ["*", "one", "name"],
                 ["*", "three", "name"],
                 ["*", "place"],
                 ["/", "place"] ]

    YPath.each_path("/*/((one|three)/name|place)|//place") do |path|
      path.segments.should == expected.shift
    end
  end

end
