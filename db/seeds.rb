# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SubscriptionPlan.destroy_all

default_plans = [{name: 'Bronze Box', price: 19.99}, {name: 'Silver Box', price: 49}, {name: 'Gold Box', price: 99}]

default_plans.each do |default_plan|
  SubscriptionPlan.create(name: default_plan[:name], price: default_plan[:price])
end
