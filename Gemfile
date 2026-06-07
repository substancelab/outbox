# frozen_string_literal: true

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1.3"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Vite integration for Rails [https://vite-ruby.netlify.app]
gem "vite_rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# UI component library built with ViewComponents, Flowbite, and Tailwind CSS
gem "flowbite-components"
gem "reactionview"
gem "tailwindcss-rails", ">= 4.3.0"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 2.1"
gem "sqlite_crypto" # UUID primary key support for SQLite

# Liquid template rendering [https://github.com/Shopify/liquid]
gem "liquid"

# Mailgun email delivery [https://github.com/mailgun/mailgun-ruby]
gem "mailgun-ruby"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", :platforms => [:windows, :jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", :require => false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", :platforms => [:mri, :windows], :require => "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", :require => false

  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "shoulda-matchers"

  gem "rubocop", :require => false
  gem "rubocop-capybara", :require => false
  gem "rubocop-factory_bot", :require => false
  gem "rubocop-performance", :require => false
  gem "rubocop-rails", :require => false
  gem "rubocop-rspec", :require => false
  gem "rubocop-rspec_rails", :require => false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Run stuff automatically
  gem "guard"
  gem "guard-livereload"
  gem "guard-rspec"
  gem "guard-rubocop"
  gem "ostruct" # required by one of the guard gems
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webmock"
end
