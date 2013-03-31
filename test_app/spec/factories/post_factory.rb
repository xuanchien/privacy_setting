FactoryGirl.define do 
	factory :post do 
		sequence(:content){|n| "Content #{n}"}
	end
end