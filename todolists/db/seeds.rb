# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create! [
	{username: "Fiorina", password_digest:'1111'},
	{username: "Trump", password_digest:'1111'},
	{username: "Carson", password_digest:'1111'},
	{username: "Clinton", password_digest:'1111'},
]

User.find_by!(username: "Fiorina").create_profile(first_name: "Carly", last_name: "Fiorina", birth_year: "1954", gender: 'female')
User.find_by!(username: "Trump").create_profile(first_name: "Donald", last_name: "Trump", birth_year: "1946", gender: 'male')
User.find_by!(username: "Carson").create_profile(first_name: "Ben", last_name: "Carson", birth_year: "1951", gender: 'male')
User.find_by!(username: "Clinton").create_profile(first_name: "Hillary", last_name: "Clinton", birth_year: "1947", gender: 'female')

one_year_from_today = Date.today.to_date+1.year
User.all.each do |user|
	todo_list = TodoList.create!(list_name: "new list", list_due_date: one_year_from_today)
	user.todo_lists << todo_list
end

TodoList.all.each do |todo_list|
	5.times do
		todo_item = TodoItem.create!(title: "Add twitter player card", description: "Add twitter player card with meta tags and a new audio player", due_date: one_year_from_today)
		todo_list.todo_items << todo_item
	end
end
