module RedshiftSimpleMigrator
  class Railtie < Rails::Railtie
    initializer "redshift_simple_migrator.initialization" do
      RedshiftSimpleMigrator.configure do |c|
        c.migrations_path = Rails.root.join("redshift", "migrate").to_s
        c.logger = Rails.logger
      end
    end

    config.after_initialize do
      config_yml = Rails.root.join("config", "redshift_simple_migrator.yml").to_s
      RedshiftSimpleMigrator.config.load(config_yml) if File.exist?(config_yml)
    end

    rake_tasks do
      load "redshift_simple_migrator/tasks/redshift.rake"
    end
  end
end
