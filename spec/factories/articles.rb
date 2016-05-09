FactoryGirl.define do
  factory :article, class: 'Article' do
    title 'Article title'
    body 'some article...'
    user_id 1
  end
end
