class AddTodoListsToUser < ActiveRecord::Migration
  def change
    add_reference :users, :todo_lists, index: true, foreign_key: true
  end
end
