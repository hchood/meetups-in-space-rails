FactoryGirl.define do
  factory :meetup do
    sequence(:name) { |n| "#{n} Ice Skating" }
    location "Space Frog Pond."
    description "Magnetic ice skating rink simulates gravity."
  end

  factory :comment do
    title "I love ice skating!"
    body "Like, I really really love it."

    meetup  # same as association :meetup
  end
end
