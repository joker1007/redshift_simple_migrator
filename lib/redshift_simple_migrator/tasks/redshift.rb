namespace :redshift do
  desc "Migrate the AWS Redshift (options: VERSION=x)"
  task migrate: [:environment] do
    begin
      migrator = RedshiftSimpleMigrator::Migrator.new
      migrator.run(ENV["VERSION"])
    ensure
      migrator.close
    end
  end

  namespace :migrate do
    desc "Display status of AWS Redshift migration (options: VERSION=x)"
    task status: [:environment] do
      begin
        migrator = RedshiftSimpleMigrator::Migrator.new
        direction, migrations = migrator.run_migrations(ENV["VERSION"])
        migrations.each do |migration|
          puts "#{direction} #{migration.version} #{migration.class.to_s}"
        end
      ensure
        migrator.close
      end
    end
  end
end
