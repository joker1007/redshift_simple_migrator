module RedshiftSimpleMigrator
  class Migration
    attr_reader :connection, :version

    delegate \
      :exec,
      :escape,
      :escape_string,
      :escape_identifier,
      :escape_literal,
      to: :connection
    alias :execute :exec

    def initialize(connection, version)
      @connection = connection
      @version = version
    end

    def up
      raise NotImplementedError
    end

    def down
      raise NotImplementedError
    end
  end
end
