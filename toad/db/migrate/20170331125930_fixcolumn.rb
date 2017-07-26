class Fixcolumn < ActiveRecord::Migration
  def change
    rename_column :users, :usernamer, :username
  end
end
