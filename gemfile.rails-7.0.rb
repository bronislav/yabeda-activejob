# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in yabeda-activejob.gemspec.
gemspec

gem "rails", "~> 7.0.0"