class User < ActiveRecord::Base
  has_one :profile, dependent: :destroy
  has_many :todo_lists, dependent: :destroy
  has_many :todo_items, through: :todo_lists, source: :todo_items
  validates :username, presence: true
  validates :password, presence: true
  validates :password, confirmation: true

  def get_completed_count
    self.todo_items.where(completed: true).count
  end

  def authenticate(password)
    if self.password == password
      return true
    end
    false
  end


end
