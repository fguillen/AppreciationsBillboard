password = "password"
email = "admin@example.com"

AdminUser.create!(
  :name => "Super Admin",
  :email => email,
  :password => password,
  :password_confirmation => password
)

puts "AdminUser created #{email}/#{password}"
