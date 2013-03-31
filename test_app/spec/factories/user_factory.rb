FactoryGirl.define do 
	factory :user do 
		sequence(:username){|n| "username#{n}"}
	end
end