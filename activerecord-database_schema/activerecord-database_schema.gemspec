$:.push File.expand_path("../lib", __FILE__)

version = File.read(File.expand_path("../../ACTIVERECORD_EXTENDED_SUPPORT_VERSION", __FILE__)).strip
ar_version = File.read(File.expand_path("../../ACTIVERECORD_VERSION", __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activerecord-database_schema"
  s.version     = version
  s.authors     = ["Roberto Quintanilla Gonzalez"]
  s.email       = ["roberto.quintanilla@gmail.com"]
  s.homepage    = "https://github.com/vovimayhem"
  s.summary     = "Support for unsigned columns and comments in ActiveRecord Schema Dumps."
  s.description = "Support for unsigned columns and comments in ActiveRecord Schema Dumps."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", ar_version

  s.add_development_dependency "mysql2"
end
