require 'active_support/inflector'

module RedshiftSimpleMigrator
  class Migrator
    attr_reader :connection, :migrations_path, :schema_migrations_table_name

    delegate :close, to: :connection

    MIGRATION_FILE_PATTERN = /^(?<version>\d+)_(?<migration_name>.*)\.rb$/.freeze

    def initialize
      config = RedshiftSimpleMigrator.config
      @connection = Connection.new
      @migrations_path = config.migrations_path
      @schema_migrations_table_name =
        @connection.quote_ident(config.schema_migrations_table_name)

      @current_version_is_loaded = nil
      @current_migrations = nil
      @all_migrated_versions_is_loaded = nil
    end

    def current_migrations
      return @current_migrations if @current_migrations

      migrations = Dir.entries(migrations_path).map do |name|
        if match = MIGRATION_FILE_PATTERN.match(name)
          require File.expand_path(File.join(migrations_path, name))
          migration_class = match[:migration_name].camelcase.constantize
          migration_class.new(connection, match[:version].to_i)
        end
      end
      @current_migrations = migrations.compact
    end

    def run_migrations(target_version = nil)
      direction = detect_direction(target_version)
      if direction == :up
        migrations = current_migrations.select do |m|
          include_target = target_version ? target_version.to_i >= m.version : true
          include_target && ! all_migrated_versions.include?(m.version)
        end
        return direction, migrations.sort_by(&:version)
      else
        migrations = current_migrations.select do |m|
          target_version.to_i < m.version &&
            m.version <= current_version.to_i
        end
        return direction, migrations.sort_by {|m| -(m.version) }
      end
    end

    def current_version
      return @current_version if @current_version_is_loaded

      connection.async_exec(get_version_query) do |result|
        versions = result.map do |row|
          row["version"].to_i
        end
        @current_version = versions.max
        @current_version_is_loaded = true
        @current_version
      end
    rescue PG::UndefinedTable
      connection.exec(create_schema_migrations_table_query)
      retry
    end

    def all_migrated_versions
      return @all_migrated_versions if @all_migrated_versions_is_loaded

      connection.async_exec(get_version_query) do |result|
        versions = result.map do |row|
          row["version"].to_i
        end
        @all_migrated_versions = versions
        @all_migrated_versions_is_loaded = true
        @all_migrated_versions
      end
    rescue PG::UndefinedTable
      connection.exec(create_schema_migrations_table_query)
      retry
    end

    def run(target_version = nil)
      direction, migrations = run_migrations(target_version)
      connection.with_transaction do
        migrations.each do |m|
          m.send(direction)
          if direction == :up
            insert_version(m.version)
          else
            remove_version(m.version)
          end
        end
      end
    end

    private

    def get_version_query
      "SELECT version FROM #{schema_migrations_table_name}"
    end

    def create_schema_migrations_table_query
      "CREATE TABLE IF NOT EXISTS #{schema_migrations_table_name} (version text NOT NULL)"
    end

    def detect_direction(target_version)
      return :up unless target_version && current_version

      if current_version.to_i <= target_version.to_i
        :up
      else
        :down
      end
    end

    def insert_version(version)
      connection.exec_params(<<-SQL, [version.to_s])
      INSERT INTO #{schema_migrations_table_name} (version) VALUES ($1)
      SQL
    end

    def remove_version(version)
      connection.exec_params(<<-SQL, [version.to_s])
      DELETE FROM #{schema_migrations_table_name} WHERE version = $1
      SQL
    end
  end
end
