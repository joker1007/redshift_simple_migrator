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
      :quote_ident,
      :escape_literal,
      to: :connection

    def initialize
      @connection = PG.connect(RedshiftSimpleMigrator.config.database_config)
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
