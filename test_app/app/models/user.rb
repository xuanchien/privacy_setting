class User < ActiveRecord::Base
	include PrivacySetting::UserPermission

  attr_accessible :username
  has_many :posts

  def become_friend_with(user)
  	@friend = user
  end

  def friend_with?(user)
  	return (@friend == user)
  end
end
