require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

class Constructor
  attr_reader :composer

  def self.new_by_string yaml_string
    scanner = Scanner.new(yaml_string)
    parser = Parser.new(scanner)
    resolver = Resolver.new
    @composer = Composer.new(parser,resolver)
    new(@composer)
  end

end
