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
    "\nstr".should load_as(expected)

    "\xC3\xBC".should load_as("\xC3\xBC")
    "\"\\xC3\\xBC\"".should load_as("\xC3\xBC")
    "---\n\"\\xC3\\xBC\"".should load_as("\xC3\xBC")

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

  it "could load empty content" do
    "{foo : !!str\n}".should load_as({ "foo" => ""})
    "{foo : !!str , !!str : bar,}".should load_as({ "foo" => "", "" => "bar"})

    # Completely empty nodes are only valid when following some explicit indication for their existence.
    lambda { RbYAML.load("{foo : !!str}") }.should raise_error
  end

  it "should load string which include strange characters successfully" do
    "--- \n,a".should load_as(",a")
    "foobar: >= 123".should load_as({ "foobar" => ">= 123"})
    "foobar: |= 567".should load_as({ "foobar" => "|= 567"})
    "---\nfoo: \tbar".should load_as({ "foo" => "bar"})
  end

  it "could load asterisk" do
    "--- \n*.rb".should load_as("*.rb")
    %Q{--- \n'*.rb'}.should load_as("*.rb")

    "--- \n&.rb".should load_as("&.rb")
    %Q{--- \n'&.rb'}.should load_as("&.rb")

    lambda {RbYAML.load("--- \n&r.b")}.should raise_error
    lambda {RbYAML.load("--- \n*r.b")}.should raise_error
  end

  it "could load integer" do
    "47".should load_as(47)
    "0".should load_as(0)
    "-1".should load_as(-1)
  end

  it "could load block mapping" do
    expected = { "a" => "b", "c" => "d"}
    "a: b\nc: d".should load_as(expected)
    "c: d\na: b".should load_as(expected)
  end

  it "could load flow mapping" do
    expected = { "a" => "b", "c" => "d"}
    "{a: b, c: d}".should load_as(expected)
    "{c: d,\na: b}".should load_as(expected)
  end

  it "could load internal character" do
    "--- \nbad_sample: something:(\n".should load_as({ "bad_sample" => "something:(" })
    "--- \nbad_sample: something:".should load_as({ "bad_sample" => "something:" })
    lambda { RbYAML.load("--- \nbad_sample: something:\n") }.should raise_error
  end

  it "should load no blank mapping block as string" do
    "a:b".should load_as("a:b")
    "---\na: b(".should load_as({ "a" => "b(" })
    "---\na: b:c".should load_as({ "a" => "b:c" })
    "---\na: b:".should load_as({ "a" => "b:" })
  end

  it "should load nest mapping" do
    "a:\n - b\n - c".should load_as({ "a" => ["b", "c"] })
  end

  it "could load builtin tag" do
    expected = "str"
    "!!str str".should load_as(expected)
    "%YAML 1.1\n---\n!!str str".should load_as(expected)
    "%YAML 1.0\n---\n!str str".should load_as(expected)
    "%YAML 1.2\n---\n!!str str".should load_as(expected)
    lambda { RbYAML.load("%YAML 1.1\n%YAML 1.1\n--- !!str str") }.should raise_error(RbYAML::ParserError, "found duplicate YAML directive")
    lambda { RbYAML.load("%YAML 2.0\n---\n!!str str") }.should raise_error(RbYAML::ParserError, "found incompatible YAML document (version 1.* is required)")
  end

  it "could load ruby object" do
    "--- !ruby/object:TestBean\nname: spritesun\nage: 20\nborn: 1988-06-27\n".should load_as(TestBean.new("spritesun", 20, Date.civil(1988, 6, 27)))
  end
end
