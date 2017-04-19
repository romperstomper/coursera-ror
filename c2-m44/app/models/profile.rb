class Profile < ActiveRecord::Base
  belongs_to :user
  validate :first_or_last
  validate :male_or_female
  validate :boy_named_sue

  def first_or_last
    unless first_name or last_name
      errors.add(:first_name, "names cannot be empty")
    end
  end

  def male_or_female
    unless gender == 'male' or gender == 'female'
      errors.add(:gender, 'gender must be male or female')
    end
  end

  def boy_named_sue
    if gender == 'male' and first_name == 'Sue'
      errors.add(:gender, 'no boys name sue allowed!')
    end
  end
  
  def self.get_all_profiles(min_year, max_year)
    self.where("birth_year BETWEEN :min_year AND :max_year", min_year: min_year, max_year: max_year).order(birth_year: :asc)
  end
end
