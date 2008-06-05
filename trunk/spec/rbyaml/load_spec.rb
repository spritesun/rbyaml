# Copyright (c) 2007, Evan Phoenix.
# Distributed under BSD License.
# Modified by Long Sun <spritesun@gmail.com>.

require File.join(File.dirname(__FILE__), "rbyaml_helper")

describe "RbYAML#load" do
  after :each do
    File.delete $test_file if File.exist? $test_file
  end

  it "should return a document from current io stream when io provided" do
    File.open($test_file, 'w') do |io|
      RbYAML.dump( ['badger', 'elephant', 'tiger'], io )
    end
    File.open($test_file) { |yf| RbYAML.load( yf ) }.should == ['badger', 'elephant', 'tiger']
  end

  it "should return a symbol when accepting a string include symbol" do
    "--- :locked".should load_as(:locked)
  end

  it "should load symbol stream which contains blank successfully" do
    expected = { :'user name' => 'This is the user name.'}
    %Q{:user name: This is the user name.}.should load_as(expected)
  end

  it "should load String successfully" do
    expected = "str"
    "str".should load_as(expected)
    " str".should load_as(expected)
    %Q{'str'}.should load_as(expected)
    "\"str\"".should load_as(expected)
    "\n str".should load_as(expected)
    "--- str".should load_as(expected)
    "---\nstr".should load_as(expected)
    "--- \nstr".should load_as(expected)
    "--- \n str".should load_as(expected)
    %Q{--- 'str'}.should load_as(expected)
    "!!str str".should load_as(expected)

    "!!str 1.0".should load_as("1.0")
  end

  it "should load !str as application tag in YAML1.0" do
    load_yaml "1.0"

    "!str str".should load_as("str")
    "!str 1.0".should load_as("1.0")

    load_yaml
  end

  it "should load Array successfully" do
    expected = ["a", "b", "c"]
    "--- \n- a\n- b\n- c\n".should load_as(expected)
    "--- [a, b, c]".should load_as(expected)
    "[a, b, c]".should load_as(expected)
  end

  it "should load string with empty value as empty string" do
    "---\n!!str".should load_as(String.new)
    "---\n- !!str\n- :symbol".should load_as([String.new, :symbol])

    load_yaml "1.0"
    "---\n!str".should load_as(String.new)
    load_yaml
  end

  it "should load empty yaml file as nil" do
    "".should load_as(nil)
  end

  it "should load emtpy int and null tag" do
    "!!int".should load_as(0)
    "!!null".should load_as(nil)
  end

  it "should load document start marker" do
    "---\n".should load_as(nil)
    "--- ---\n".should load_as("---")

    "---".should load_as("---")
    "---\0".should load_as("---")
  end

  it "should not load string after \0" do
    "begin\0end".should load_as("begin")
    "---\n\0word".should load_as(nil)
  end

  it "should load canonical timestamp" do
    #     "2007-01-01 01:12:34".should load_as({ "a" => "2007-01-01 01:12:34"})
    "2001-12-15T02:59:43.1Z".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 100000))
    # space separated:  2001-12-14 21:59:43.10 -5
    # no time zone (Z): 2001-12-15 2:59:43.10
    # date (00:00:00Z): 2002-12-14
  end

  it "should load fraction of a second" do
    "2001-12-15T02:59:43.12Z".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 120000))
    "2001-12-15T02:59:43.123456Z".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 123456))
    "2001-12-15T02:59:43.1234567890000Z".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 123457))
  end

  it "should load valid iso8601 timestamp" do
    "2001-12-14t21:59:43.10-05:00".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 1e5))
    "2001-12-14t21:59:43.10 +00:00".should load_as(Time.gm(2001, "dec", 14, 21, 59, 43, 1e5))
  end

  it "should load space separated timestamp" do
    "2001-12-14 21:59:43.10 -5".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 1e5))
  end

  it "should load no time zone (Z) timestamp as UTC" do
    "2001-12-15 2:59:43.10".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 1e5))
    "2001-12-15 2:59:43".should load_as(Time.gm(2001, "dec", 15, 2, 59, 43, 0))
  end

  it "should load no time part timestamp as date" do
    "2002-12-14".should load_as(Date.civil(2002, 12, 14))
  end

  it "should load sequence as array, map as hash" do
    "---\n- foo\n- foo\n- [foo]\n- [foo]\n- {foo: foo}\n- {foo: foo}\n".should load_as(["foo", "foo", ["foo"], ["foo"], { "foo" => "foo"}, { "foo" => "foo"}])
  end

  it "should load strange nesting successfully" do
    "---\nfoo: { bar }\n".should load_as({ "foo" => { "bar" => nil}})
    "---\ndefault: \n- a\n".should load_as({ "default" => ["a"]})
    "---\nfoo: {bar, qux}".should load_as({ "foo" => { "bar" => nil, "qux" => nil}})
  end

  it "should load uncompleted map smoothly" do
    "{foo}".should load_as({ "foo" => nil})
    "{ foo }".should load_as({ "foo" => nil})
#     "{ foo:}".should load_as({ "foo:" => nil})
    "{ foo:\n}".should load_as({ "foo" => nil})
    "{ foo: }".should load_as({ "foo" => nil})
    "{ foo, bar }".should load_as({ "foo" => nil, "bar" => nil})
  end

  it "should load duplicate key/index successfully, the value should be the last declared value" do
    "{foo: bar, foo: bar2}".should load_as({ "foo" => "bar2"})
  end
end
