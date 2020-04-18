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
100.times do
  appreciable_users_to = (rand(2) + 1).times.map { AppreciableUser.all.sample }
  num_sentences = rand(3) + 1

  appreciation =
    Appreciation.create!(
      by: AppreciableUser.all.sample,
      to: appreciable_users_to,
      message: Faker::Lorem.sentences(number: num_sentences),
    )

  if rand(2).zero?
    appreciation.pic.attach(io: File.open("#{Rails.root}/test/fixtures/files/thankyou.gif"), filename: "thankyou.gif")
  else
    appreciation.pic.attach(io: File.open("#{Rails.root}/test/fixtures/files/yourule.png"), filename: "yourule.png")
  end

  print "."
end
