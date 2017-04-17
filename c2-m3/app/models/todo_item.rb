class TodoItem < ActiveRecord::Base
  def self.completed_count
    self.where(completed: true).count
  end
end
