password = "p4sswORd"
email = "admin@example.com"

if !AdminUser.where(email: email).exists?
  AdminUser.create!(
    :name => "Super Admin",
    :email => email,
    :password => password,
    :password_confirmation => password
  )
  puts "AdminUser created #{email}/#{password}"
end

puts "Creating AppreciableUser"
10.times do
  AppreciableUser.create!(
    name: Faker::FunnyName.unique.name,
    email: Faker::Internet.unique.email
  )
  print "."
end
puts

puts "Creating Appreciations"
20.times do
  appreciable_users_to = (rand(2) + 1).times.map { AppreciableUser.all.sample }
  num_paragraphs = rand(5) + 1

  appreciation =
    Appreciation.create!(
      by: AppreciableUser.all.sample,
      to: appreciable_users_to,
      message: Faker::Lorem.paragraphs(number: num_paragraphs).join("\n"),
    )

  print "."
end
