# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create users
users = User.create([
  { username: 'admin', password: 'testing1234', email: 'admin@railsapp.com' },
  { username: 'testuser', password: 'testing1234', email: 'test@railsapp.com' }
])

# # Create publishers by users
admin = User.find_by(username: 'admin')
test_user = User.find_by(username: 'testuser')

Publisher.create([
  { name: 'Publisher A', description: 'The description for publisher A', creator: admin, updater: admin},
  { name: 'Publisher B', description: 'The description for publisher B', creator: test_user, updater: test_user}
])

# Create authors by users
publisher_A = Publisher.find_by(name: 'Publisher A')
publisher_B = Publisher.find_by(name: 'Publisher B')

author_A = Author.new(name: 'Author A', description: 'The description for author A', creator: admin, updater: admin)
author_B = Author.new(name: 'Author B', description: 'The description for author B', creator: test_user, updater: test_user)
author_A.save
author_B.save

# Create books by users
book_A = Book.new(name: 'Book A', abstract: 'The description for book A', price: 30.0, creator: admin, updater: admin, publisher: publisher_A)
book_B = Book.new(name: 'Book B', abstract: 'The description for book B', price: 20.0, creator: admin, updater: admin,  publisher: publisher_B)
book_C = Book.new(name: 'Book C', abstract: 'The description for book C', price: 15.0, creator: admin, updater: admin,  publisher: publisher_B)
book_D = Book.new(name: 'Book D', abstract: 'The description for book D', price: 12.0, creator: test_user, updater: test_user,  publisher: publisher_A)
book_A.save
book_B.save
book_C.save
book_D.save

# Pivot table
author_A.books << [book_B, book_C, book_D]
author_B.books << [book_A, book_B, book_D]
author_A.save
author_B.save
