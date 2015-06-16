class CreateUsers < RedshiftSimpleMigrator::Migration
  def up
    execute <<-SQL
      CREATE TABLE users (name text);
    SQL
  end

  def down
    execute <<-SQL
      DROP TABLE users;
    SQL
  end
end
