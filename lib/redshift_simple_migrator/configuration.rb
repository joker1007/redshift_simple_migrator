require 'singleton'
require 'active_support/configurable'

module RedshiftSimpleMigrator
  class Configuration
    include Singleton
    include ActiveSupport::Configurable

    config_accessor :schema_migrations_table_name do
      "schema_migrations"
    end

    config_accessor :logger do
      Logger.new($stdout)
    end

    config_accessor :migrations_path

    config_accessor :host, :port, :dbname, :user, :password, :connect_timeout

    def load(config_file, default_env = "development")
      env = ENV["REDSHIFT_ENV"] || ENV["RAILS_ENV"] || ENV["RACK_ENV"] || default_env
      config = YAML.load_file(config_file)[env]
      config.each do |k, v|
        send("#{k}=", v)
      end
    end

    def database_config
      {
        host: host,
        port: port,
        dbname: dbname,
        user: user,
        password: password,
        connect_timeout: connect_timeout
      }
    end
  end
end
