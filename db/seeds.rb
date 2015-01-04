tony = User.where(
  f_name: "Tony",
  l_name: "Stark",
  email: "tony@stark.com",
  daily_goal: 100
).first_or_create!

bruce = User.where(
  f_name: "Bruce",
  l_name: "Banner",
  email: "hulk@gmail.com",
  daily_goal: 1000
).first_or_create!

Friendship.create_friendship(tony, bruce)
tony.workouts.create_template_sets([10, 10, 10])
