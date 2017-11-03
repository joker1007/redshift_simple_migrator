require "redshift_simple_migrator/version"

module RedshiftSimpleMigrator
  class << self
    def config
      RedshiftSimpleMigrator::Configuration.instance
    end

    def configure
      yield self.config
    end

    def logger
      config.logger
    end
  end
end

require "redshift_simple_migrator/configuration"
require "redshift_simple_migrator/connection"
require "redshift_simple_migrator/migrator"
require "redshift_simple_migrator/migration"
require "redshift_simple_migrator/cli"
require "redshift_simple_migrator/tasks/redshift"

if defined?(Rails)
  require "redshift_simple_migrator/railtie"
end
