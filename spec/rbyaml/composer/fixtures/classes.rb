require File.join(File.dirname(__FILE__), '..', '..', '..', 'spec_helper')

module ComposerSpecs
  class RbYAML::Composer
    def self.new_by_string yaml_string
      scanner = RbYAML::Scanner.new(yaml_string)
      parser = RbYAML::Parser.new(scanner)
      resolver = RbYAML::Resolver.new
      new(parser,resolver)
    end
  end
end
