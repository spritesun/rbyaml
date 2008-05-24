require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

class RbYAML::Constructor
  attr_reader :composer

  def self.new_by_string yaml_string
    scanner = RbYAML::Scanner.new(yaml_string)
    parser = RbYAML::Parser.new(scanner)
    resolver = RbYAML::Resolver.new
    @composer = RbYAML::Composer.new(parser,resolver)
    new(@composer)
  end
end
