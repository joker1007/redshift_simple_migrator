# RedshiftSimpleMigrator

this gem is super simple migrator for AWS Redshift.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redshift_simple_migrator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redshift_simple_migrator

## Usage

```sh
# List execute migrations
$ redshift_simple_migrator list <TARGET_VERSION> -c <config.yml> -p <migrations_path>

# Execute migration
$ redshift_simple_migrator migrate <TARGET_VERSION> -c <config.yml> -p <migrations_path>
```

### config.yml example

```yml
default: &default
  host: hogehoge.redshift.amazonaws.com
  port: 5439
  dbname: sample
  user: admin
  password: password
  connect_timeout: 30000

development:
  <<: *default
```

If you want to change target environment, set `REDSHIFT_ENV` environment variable.
For example, `REDSHIFT_ENV=prouduction redshift_simple_migrator migrate -c config.yml -p db/migrate`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec redshift_simple_migrator` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joker1007/redshift_simple_migrator.

