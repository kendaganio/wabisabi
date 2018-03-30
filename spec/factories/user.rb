FactoryBot.define do
  factory :user do
    email 'test1@gmail.com'
    password 'test123'
    password_confirmation 'test123'
  end

  factory :test_user, class: User do
    email 'login@mailinator.com'
    password 'loginpass'
    password_confirmation 'loginpass'
  end
end
