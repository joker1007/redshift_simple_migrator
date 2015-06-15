require 'thor'

module RedshiftSimpleMigrator
  class CLI < Thor
    desc "version", "Show migration version"
    option :config, required: true, type: :string, aliases: :c
    def version
      with_migrator do |m|
        current_version = m.current_version
        puts "Current version is #{current_version}"
      end
    end

    desc "list [VERSION]", "List migration definitions"
    option :config, required: true, type: :string, aliases: :c
    option :path, required: true, type: :string, aliases: :p
    def list(version = nil)
      with_migrator do |m|
        m.migrations_path = migrations_path
        run_migrations = m.run_migrations(version)
        run_migrations.each do |migration|
          puts "#{migration.version} #{migration.class.to_s}"
        end
      end
    end

    desc "migrate [VERSION]", "run migration"
    option :config, required: true, type: :string, aliases: :c
    option :path, required: true, type: :string, aliases: :p
    def migrate(version = nil)
      with_migrator do |m|
        m.migrations_path = migrations_path
        m.run(version)
      end
    end

    private

    def migrator(config_file)
      connection = Connection.init_with_config_file(config_file)
      Migrator.new(connection)
    end

    def config_file
      raise "Config file is not found" unless File.exist?(options[:config])
      options[:config]
    end

    def migrations_path
      raise "Migrations path is not found" unless File.exist?(options[:path])
      options[:path]
    end

    def with_migrator
      migrator = migrator(config_file)
      yield migrator
    ensure
      migrator.close
    end
  end
end
