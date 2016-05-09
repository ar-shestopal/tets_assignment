# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin         = User.find_by(email: 'admin@test.com') || User.create(name: 'Admin', email: 'admin@test.com', password: 'password', role: :admin)
regular_user  = User.find_by(email: 'user@test.com')  || User.create(name: 'User',  email: 'user@test.com',  password: 'password', role: :regular_user)

article1 = admin.articles.find_or_create_by(title: 'Article 1', body: 'Some article text...')
article2 = regular_user.articles.find_or_create_by(title: 'Article 2', body: 'Another article text...')

admin.comments.find_or_create_by(body: 'Admin comment for Article 1', article: article1)
admin.comments.find_or_create_by(body: 'Admin comment for Article 2', article: article2)

regular_user.comments.find_or_create_by(body: 'Regular User comment for Article 1', article: article1)
