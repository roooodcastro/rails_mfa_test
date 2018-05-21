source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Gems needed for the 2FA functionality
gem 'base32'
gem 'rotp'
gem 'rqrcode'

# Other Rails gems
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap'
gem 'jquery-rails'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'
gem 'sass-rails', '~> 5.0'
gem 'sqlite3'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end
