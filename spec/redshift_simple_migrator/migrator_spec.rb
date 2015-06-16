RSpec.describe RedshiftSimpleMigrator::Migrator do
  describe '#run' do
    let(:migrator) { RedshiftSimpleMigrator::Migrator.new }

    it "do migrate" do
      expect { migrator.connection.exec("SELECT * FROM users") }.to raise_error(PG::UndefinedTable)
      migrator.run
      expect { migrator.connection.exec("SELECT * FROM users") }.not_to raise_error(PG::UndefinedTable)
    end
  end
end
