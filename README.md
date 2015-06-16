# RedshiftSimpleMigrator

this gem is super simple migrator for AWS Redshift (and PostgreSQL).

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

### Define migration

Migration definition is like ActiveRecord::Migration,
but this gem supports only `execute` method.
It has no other migration dsl.

#### Migration File

```ruby
class CreateKpiMiddleTable < RedshiftSimpleMigrator::Migration
  def up
    execute <<-SQL
      CREATE TABLE company_users DISTKEY (id) AS
      SELECT
        a.id,
        a.company_id
      FROM
        users a
          INNER JOIN companies b ON a.company_id = b.id;
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE company_users;
    SQL
  end
end
```

#### File name convention

File name convention is same with ActiveRecord::Migration.

```
% ls redshift/migrate/
001_create_kpi_middle_table.rb
```

### Command

```sh
# Show current migration version
$ redshift_simple_migrator version -c <config.yml>

# List execute migrations
$ redshift_simple_migrator list <TARGET_VERSION> -c <config.yml> -p <migrations_path>

# Execute migration
$ redshift_simple_migrator migrate <TARGET_VERSION> -c <config.yml> -p <migrations_path>
```

If you use with rails, config is autoloaded from `config/redshift_simple_migrator.yml`, and define Rake tasks.

### Rake tasks

```
rake redshift:migrate                   # Migrate the AWS Redshift (options: VERSION=x)
rake redshift:migrate:status            # Display status of AWS Redshift migration (options: VERSION=x)
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
  schema_migrations_table_name: redshift_schema_migrations

development:
  <<: *default
```

If `schema_migrations_table_name` table doesn't exist, this gem creates the table automatically.

`schema_migrations` table schema is following.

```sql
CREATE TABLE <schema_migrations_table_name> (version text NOT NULL)
```

## TODO
- Refine `migrations_path` config.
- Write test codes.

If you want to change target environment, set `REDSHIFT_ENV` environment variable.
For example, `REDSHIFT_ENV=prouduction redshift_simple_migrator migrate -c config.yml -p db/migrate`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec redshift_simple_migrator` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joker1007/redshift_simple_migrator.

