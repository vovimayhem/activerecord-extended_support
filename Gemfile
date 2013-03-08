source 'https://rubygems.org'

gemspec

gem 'activerecord'

group :doc do
  # The current sdoc cannot generate GitHub links due
  # to a bug, but the PR that fixes it has been there
  # for some weeks unapplied. As a temporary solution
  # this is our own fork with the fix.
  gem 'sdoc',  :git => 'git://github.com/fxn/sdoc.git'
  gem 'RedCloth', '~> 4.2'
  gem 'w3c_validators'
end

platforms :ruby do
  gem 'yajl-ruby'

  # AR
  gem 'sqlite3', '~> 1.3.5'

  group :development do
    gem 'mysql2', '>= 0.3.10'
  end
end

platforms :jruby do
  gem 'json'
  gem 'activerecord-jdbcsqlite3-adapter', '>= 1.2.0'
  group :development do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.2.0'
  end
end
