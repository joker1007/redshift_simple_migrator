require 'thor'

module RedshiftSimpleMigrator
  class CLI < Thor
    desc "version", "Show migration version"
    option :config, required: true, type: :string, aliases: :c
    option :path, required: true, type: :string, aliases: :p
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
        direction, migrations = m.run_migrations(version)
        migrations.each do |migration|
          puts "#{direction} #{migration.version} #{migration.class.to_s}"
        end
      end
    end

    desc "migrate [VERSION]", "run migration"
    option :config, required: true, type: :string, aliases: :c
    option :path, required: true, type: :string, aliases: :p
    def migrate(version = nil)
      with_migrator do |m|
        m.run(version)
      end
    end

    private

    def load_config
      raise "Config file is not found" unless File.exist?(options[:config])
      RedshiftSimpleMigrator.config.load(options[:config])
    end

    def set_migrations_path
      raise "Migrations path is not found" unless File.exist?(options[:path])
      RedshiftSimpleMigrator.config.migrations_path = options[:path]
    end

    def migrator
      return @migrator if @migrator

      load_config
      set_migrations_path
      @migrator = Migrator.new
    end

    def with_migrator
      yield migrator
    ensure
      migrator.close if migrator
    end
  end
end
