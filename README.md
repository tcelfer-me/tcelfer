# Tcelfer

### [t]cel-fer:
  - A fun way to keep track of simple summaries of your month/year.

## Requirements
* Ruby 2.6.0
* Sqlite3

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tcelfer', '~> 0.2'
```

And then execute:
```
$ bundle
```
Or install it yourself as:
```
$ gem install tcelfer
```
## Usage

```
# Record your day
$ tcelfer day [-d 2018-12-31]

# Reflect on your month
$ tcelfer report [-y|--year=)YEAR] -m|--month=MON [--legend]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, and push git commits and tags

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/agargiulo/tcelfer.
