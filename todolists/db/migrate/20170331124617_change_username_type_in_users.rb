class ChangeUsernameTypeInUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :username, :string
  end

  def self.down
    change_column :users, :username, :text
  end

end
