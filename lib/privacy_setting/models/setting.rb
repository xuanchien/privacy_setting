module PrivacySetting
	class Setting < ActiveRecord::Base
		attr_accessible :rule_name, :scope, :object_value
		validates_presence_of :rule_name
		validates_presence_of :scope
		validates :scope, :inclusion => [PUBLIC, FRIENDS_ONLY, PRIVATE]
	end
end