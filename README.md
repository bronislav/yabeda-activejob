# NOT READY FOR USE
### STILL DEBUGGING SOME METRICS 

# Yabeda::ActiveJob
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
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install yabeda-activejob
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
