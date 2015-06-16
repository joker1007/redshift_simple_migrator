require "redshift_simple_migrator/version"

module RedshiftSimpleMigrator
  def self.config
    RedshiftSimpleMigrator::Configuration.instance
  end

  def self.configure
    yield self.config
  end
end

require "redshift_simple_migrator/configuration"
require "redshift_simple_migrator/connection"
require "redshift_simple_migrator/migrator"
require "redshift_simple_migrator/migration"
require "redshift_simple_migrator/cli"

if defined?(Rails)
  require "redshift_simple_migrator/railtie"
end
