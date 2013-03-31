class Post < ActiveRecord::Base
	include PrivacySetting::ObjectPermission
	
  attr_accessible :content
  belongs_to :user
end
