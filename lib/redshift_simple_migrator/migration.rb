require 'active_support/concern'
require 'active_support/callbacks'

module RedshiftSimpleMigrator
  class Migration
    include ActiveSupport::Callbacks
    define_callbacks :up, :down, :execute

    set_callback :up, :before, :display_migration_up_start
    set_callback :up, :after, :display_migration_up_finish
    set_callback :down, :before, :display_migration_down_start
    set_callback :down, :after, :display_migration_down_finish

    module RunCallbacksWrapper
      def up
        run_callbacks :up do
          super
        end
      end

      def down
        run_callbacks :down do
          super
        end
      end

      def exec(*args)
        log_sql(args[0])
        super
      end

      def execute(*args)
        log_sql(args[0])
        super
      end
    end

    def self.inherited(subclass)
      subclass.class_eval do
        prepend RunCallbacksWrapper
      end
    end

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

    def display_migration_up_start
      puts "== #{self.class.to_s} up migrating =="
    end

    def display_migration_up_finish
      puts "== #{self.class.to_s} up migrated =="
    end

    def display_migration_down_start
      puts "== #{self.class.to_s} down migrating =="
    end

    def display_migration_down_finish
      puts "== #{self.class.to_s} down migrated =="
    end

    def log_sql(sql)
      puts "-- Execute --\n#{sql}"
      RedshiftSimpleMigrator.logger.info("SQL (RedshiftSimpleMigrator) #{sql}")
    end
  end
end
