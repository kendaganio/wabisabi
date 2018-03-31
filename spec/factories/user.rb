FactoryBot.define do
  factory :user do
    email 'login@mailinator.com'
    password 'loginpass'
    password_confirmation 'loginpass'
  end
end
