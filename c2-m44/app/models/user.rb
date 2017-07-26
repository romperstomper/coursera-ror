class User < ActiveRecord::Base
  has_one :profile, dependent: :destroy
  has_many :todo_lists, dependent: :destroy
  has_many :todo_items, through: :todo_lists, source: :todo_items
  validates :username, presence: true
  has_secure_password

  def authenticate(pass)
    if pass == self.password
      return self
    end
    return false
  end


  def get_completed_count
    self.todo_items.where(completed: true).count
  end
end
