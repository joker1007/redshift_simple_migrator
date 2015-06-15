require 'pg'
require 'yaml'
require 'active_support/core_ext/module'

module RedshiftSimpleMigrator
  class Connection
    attr_reader :connection

    delegate \
      :close,
      :exec,
      :async_exec,
      :exec_params,
      :escape,
      :escape_string,
      :escape_identifier,
      :escape_literal,
      to: :connection

    class << self
      def init_with_config_file(config_file, default_env = "development")
        env = ENV["REDSHIFT_ENV"] || default_env
        new(YAML.load_file(config_file)[env])
      end
    end

    def initialize(config)
      @connection = PG.connect(config)
      @connection.type_map_for_results = PG::BasicTypeMapForResults.new(@connection)
    end

    def with_transaction(&block)
      connection.exec("BEGIN")
      block.call(self)
      connection.exec("COMMIT")
    rescue => e
      connection.exec("ROLLBACK") if connection
      raise e
    end
  end
end
