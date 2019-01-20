# Tcelfer

### [t]cel-fer:
  - A fun way to keep track of simple summaries of your months.

![generated_report](/images/generated_report.png)

## Requirements
* Ruby 2.5.0+ (Tested with 2.6.0 mostly)
* Sqlite3

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tcelfer', '~> 1.0'
```

And then execute:
```bash
$ bundle
```
Or install it yourself as:
```bash
$ gem install tcelfer
```

## Setup
```bash
# Configure with one of the following:
# Just change the db location
export TCELFER_SQLITE_PATH=path/to/some_file.db
# Or copy `config/tcelfer.example.yml` and use:
export TCELFER_CONF=~/.config/tcelfer/my_conf.yml
# Initialize the database
$ bin/db_init
```

## Usage

```bash
# TODO: Find a better way to do this
# export TCELFER_SQLITE_PATH TCELFER_CONF from above
# Record your day
$ tcelfer day [-d 2018-12-31]

# Reflect on your month
$ tcelfer report [-y|--year=)YEAR] -m|--month=MON [--legend]
```
![record_day](/images/record_day.png)
![recorded_day](/images/recorded_day.png)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, and push git commits and tags

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/agargiulo/tcelfer.
