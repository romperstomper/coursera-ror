class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.text :description
      t.date :due_date
      t.string :title
      t.boolean :completed

      t.timestamps null: false
    end
  end
end
