# Yabeda::ActiveJob
[![Gem Version](https://badge.fury.io/rb/yabeda-activejob.svg)](https://badge.fury.io/rb/yabeda-activejob)
![Tests](https://github.com/Fullscript/yabeda-activejob/actions/workflows/test.yml/badge.svg)
![Rubocop](https://github.com/Fullscript/yabeda-activejob/actions/workflows/lint.yml/badge.svg)

Yabeda metrics around rails activejobs. The motivation came from wanting something similar to [yabeda-sidekiq](https://github.com/yabeda-rb/yabeda-sidekiq) for
resque but decided to generalize even more with just doing it on the activejob level since that is likely more in use
than just resque. and could implement a lot of the general metrics needed without having to leverage your used adapters
implementation and oh the redis calls. 
The intent is to have this plugin with an exporter such as [prometheus](https://github.com/yabeda-rb/yabeda-prometheus). 

## Usage
How to use my plugin.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'yabeda-activejob'
# Then add monitoring system adapter, e.g.:
# gem 'yabeda-prometheus'
```

### Registering metrics on server process start

Currently, yabeda-activejob does not automatically install on your rails server (this will be added in the future). For now to install
you can do the following: 
```ruby
# config/initializers/yabeda.rb
  Yabeda::ActiveJob.install!
```

## Metrics

- Total enqueued jobs: `activejob.enqueued_total`
- Total jobs processed: `activejob.executed_total`
- Total successful jobs processed: `activejob.success_total`
- Total failed jobs processed: `activejob.failed_total`
- Job runtime: `activejob.runtime` (in seconds)
- Job latency: `activejob.latency` (in seconds)

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
