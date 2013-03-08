$:.push File.expand_path("../lib", __FILE__)

version = File.read(File.expand_path("../../ACTIVERECORD_EXTENDED_SUPPORT_VERSION", __FILE__)).strip
ar_version = File.read(File.expand_path("../../ACTIVERECORD_VERSION", __FILE__)).strip

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "activerecord-database_comments"
  s.version     = version
  s.authors     = ["Roberto Quintanilla"]
  s.email       = ["roberto.quintanilla@gmail.com"]
  s.homepage    = "https://github.com/vovimayhem"
  s.summary     = "Allows to add column and table comments to ActiveRecord migrations."
  s.description = "Allows to add column and table comments to ActiveRecord migrations."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", ar_version
  s.add_dependency 'activerecord-database_schema', version

  s.add_development_dependency "mysql2"
end
