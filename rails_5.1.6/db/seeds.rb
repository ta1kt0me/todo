# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Task.create(name: "炊き込みご飯つくる").tap { |task| task.kinds.set(:home) }.save!
Task.create(name: "レビューする").tap { |task| task.kinds.set(:work) }.save!
Task.create(name: "洗剤").tap { |task| task.kinds.set(:work) }.save!
Task.create(name: "凧揚げ").tap { |task| task.kinds.set(:work) }.save!
