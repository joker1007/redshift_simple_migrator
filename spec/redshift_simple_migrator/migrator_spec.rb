RSpec.describe RedshiftSimpleMigrator::Migrator do
  describe '#run' do
    let(:migrator) { RedshiftSimpleMigrator::Migrator.new }
    let(:after_migrator) { RedshiftSimpleMigrator::Migrator.new }

    after do
      migrator.connection.exec("DROP TABLE IF EXISTS users")
      migrator.connection.exec("DROP TABLE IF EXISTS #{RedshiftSimpleMigrator.config.schema_migrations_table_name}")
    end

    it "do migrate" do
      expect { migrator.connection.exec("SELECT * FROM users") }.to raise_error(PG::UndefinedTable)
      migrator.run
      expect(migrator.connection.exec("SELECT * FROM users").to_a.size).to eq 0

      after_migrator.run(0)

      expect { after_migrator.connection.exec("SELECT * FROM users") }.to raise_error(PG::UndefinedTable)
    end
  end
end
