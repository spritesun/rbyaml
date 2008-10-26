require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

class Composer
  def self.new_by_string yaml_string
    scanner = Scanner.new(yaml_string)
    parser = Parser.new(scanner)
    resolver = Resolver.new
    new(parser,resolver)
  end
end
