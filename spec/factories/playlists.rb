require 'factory_girl'

FactoryGirl.define do
  factory :playlist do
    association :radio
  end
end
