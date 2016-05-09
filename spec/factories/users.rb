FactoryGirl.define do
  factory :user, class: 'User' do
    name 'User'
    email 'user@test.com'
    password 'password'
    role 'regular_user'
  end

  factory :admin, class: 'User' do
    name 'Admin'
    email 'admin@test.com'
    password 'password'
    role 'admin'
  end
end
