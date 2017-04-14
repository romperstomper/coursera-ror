class AddProfileToUser < ActiveRecord::Migration
  def change
    add_column :users, :user, :has_one
  end
end
