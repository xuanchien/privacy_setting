require 'spec_helper'

describe User do
	before do 
		PrivacySetting::Setting.delete_all
		User.delete_all
		@user = FactoryGirl.create(:user)
	end
  it "can save privacy setting" do 
  	@user.set_privacy_scope("test_rule", PrivacySetting::PUBLIC)
  	PrivacySetting::Setting.all.count.should == 1
  end

  it "can update existing privacy setting" do 
  	@user.set_privacy_scope("test_rule", PrivacySetting::PUBLIC)
  	PrivacySetting::Setting.all.count.should == 1
  	@user.set_privacy_scope("test_rule", PrivacySetting::PRIVATE)
  	PrivacySetting::Setting.all.count.should == 1
  end

  it "can get privacy setting" do 
  	@user.set_privacy_scope("test_rule", PrivacySetting::PUBLIC)
  	@user.get_privacy_scope("test_rule").should == PrivacySetting::PUBLIC
  end

  it "should return correct permission set by other user" do 
  	other_user = FactoryGirl.create(:user)

  	other_user.set_privacy_scope("test_rule", PrivacySetting::PUBLIC)
  	@user.has_permission?(other_user, "test_rule").should be_true

  	other_user.set_privacy_scope("test_rule", PrivacySetting::PRIVATE)
  	@user.has_permission?(other_user, "test_rule").should be_false
  end

  it "respects friend relationship ship" do 
  	other_user = FactoryGirl.create(:user)
  	@user.become_friend_with(other_user)

  	other_user.set_privacy_scope("test_rule", PrivacySetting::PUBLIC)
  	@user.has_permission?(other_user, "test_rule").should be_true

  	other_user.set_privacy_scope("test_rule", PrivacySetting::FRIENDS_ONLY)
  	@user.has_permission?(other_user, "test_rule").should be_true

  	other_user.set_privacy_scope("test_rule", PrivacySetting::PRIVATE)
  	@user.has_permission?(other_user, "test_rule").should be_false
  end
end
