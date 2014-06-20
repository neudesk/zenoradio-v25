source 'https://rubygems.org'
source 'https://rails-assets.org'
gem 'rails', '3.2.13'
#gem "pg", ">= 0.14.1"
gem 'mysql2', '>= 0.3'
gem "devise"
gem "simple_form"
gem "nested_form"
gem "area", git: "https://github.com/thuynguyen/area.git"
gem "madison"
gem 'gmaps4rails', '~> 2.1.2'
gem "google_visualr", ">= 2.1"
gem "has_scope"
gem "less-rails", ">= 2.2.6"
gem "twitter-bootstrap-rails", ">= 2.2.8"
gem 'client_side_validations', :git => 'git://github.com/bcardarella/client_side_validations.git', :branch => '3-2-stable'
gem 'client_side_validations-simple_form'
gem 'remotipart', '~> 1.2'
gem 'grape'
gem 'public_activity'
gem 'paperclip'
gem "acts_as_paranoid", "~>0.4.0"
gem 'font-awesome-sass'
gem 'httparty'
gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rvm', github: "capistrano/rvm"
gem 'symmetric-encryption'
gem "ransack"
gem "icheck-rails"
gem "select2-rails"
gem 'bootstrap-tagsinput-rails', git: "https://github.com/caedes/bootstrap-tagsinput-rails.git"
gem 'intercom-rails', '~> 0.2.24'
gem 'coffee-rails', '~> 3.2.1'
gem 'flot-rails', :git => "https://github.com/Kjarrigan/flot-rails.git"
gem 'rails-assets-jplayer'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'

  gem 'bootstrap-datepicker-rails'
  gem "therubyracer", ">= 0.11.3", :platform => :ruby, :require => "v8"
  gem 'uglifier', '>= 1.0.3'
end
gem "enum_column3", "~> 0.1.4"
gem 'jquery-rails'
gem "thin", ">= 1.5.0"
gem "haml-rails", ">= 0.4"

gem "cancan"
gem "faker"
gem 'kaminari-bootstrap'
#gem 'css_splitter' # => fix css issue on < IE 9

group :production do
  gem "unicorn"
end
group :development do
  gem "binding_of_caller"
  gem "better_errors"
  gem "quiet_assets"
  gem "html2haml", ">= 1.0.1"
  gem 'guard-bundler'
  gem 'guard-annotate'
  gem 'guard-spork'
  gem 'rails-erd'
  #gem 'debugger'
  gem 'debugger', '~> 1.6.6'
  gem 'pry-rails' # https://github.com/rweng/pry-rails
  gem 'hirb'
  gem "letter_opener"
  # Deploy with Capistrano
  gem 'selenium-webdriver'
end

gem 'delayed_job_active_record'
gem "daemons"
gem "daemon-spawn"

group :test do
  gem "capybara", ">= 2.0.2"
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
  gem "spork-rails"
  gem "json_spec"
  gem 'simplecov'
  gem 'headless'
end

group :development, :test do
  gem "rspec-rails", ">= 2.12.2"
  gem "spork"
  gem "awesome_print"
  gem 'cucumber-rails', :require => false
end

gem "factory_girl_rails", ">= 4.2.0"
gem "dalli"
