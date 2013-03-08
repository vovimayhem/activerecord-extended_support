# encoding: utf-8

version = File.read(File.expand_path("../ACTIVERECORD_EXTENDED_SUPPORT_VERSION",__FILE__)).strip
ar_version = File.read(File.expand_path("../ACTIVERECORD_VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'activerecord-extended_support'
  s.version     = version
  s.summary     = 'A collection of gems aimed to provide extended database support.'
  s.description = 'A collection of gems aimed to provide extended database support (Unsigned columns, Comments, etc).'

  s.required_ruby_version     = '>= 1.8.7'
  s.required_rubygems_version = ">= 1.3.6"

  s.author            = 'Roberto Quintanilla Gonzalez'
  s.email             = 'roberto.quintanilla@gmail.com'
  s.homepage          = 'https://github.com/vovimayhem'

  s.add_dependency "activerecord", ar_version
  s.add_dependency 'activerecord-database_comments',          version
  s.add_dependency 'activerecord-database_unsigned_columns',  version
  s.add_dependency 'activerecord-database_schema',            version

  s.add_development_dependency "mysql2"
end