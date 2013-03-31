require 'spec_helper'

describe Post do
	before do 
		Post.delete_all
		@user = FactoryGirl.create(:user)
		@post = FactoryGirl.create(:post, :user => @user)
	end
  it "allows owner to set privacy setting" do 
  	@post.privacy_scope = PrivacySetting::PUBLIC
  	@post.privacy_scope.should == PrivacySetting::PUBLIC
  	@post.save
  end

  it "returns privacy scope" do 
  	@post.privacy_scope = PrivacySetting::PRIVATE
  	@post.save
  	@post.privacy_scope.should == PrivacySetting::PRIVATE
  end

  context "non-friend relationship" do 
  	before do 
  		@other_user = FactoryGirl.create(:user)
  	end

  	it "should return true with PUBLIC permission" do 
  		@post.privacy_scope = PrivacySetting::PUBLIC
	  	@post.save
	  	@post.has_permission_with?(@other_user).should be_true
  	end

  	it "should return false with FRIENDS_ONLY permission" do 
  		@post.privacy_scope = PrivacySetting::FRIENDS_ONLY
	  	@post.save
	  	@post.has_permission_with?(@other_user).should be_false
  	end

  	it "should return false with PRIVATE permission" do 
  		@post.privacy_scope = PrivacySetting::PRIVATE
	  	@post.save
	  	@post.has_permission_with?(@other_user).should be_false
  	end
  end


  context "friend relationship" do 
  	before do 
  		@other_user = FactoryGirl.create(:user)
  		@other_user.become_friend_with(@user)
  	end
  	it "should return true with PUBLIC permission" do 
  		

  		@post.privacy_scope = PrivacySetting::PUBLIC
  		@post.save
	  	@post.has_permission_with?(@other_user).should be_true

  	end

  	it "should return true with FRIENDS ONLY permission" do 
  		@post.privacy_scope = PrivacySetting::FRIENDS_ONLY
	  	@post.save
	  	@post.has_permission_with?(@other_user).should be_true
  	end

  	it "should return false with PRIVATE permission" do 
  		@post.privacy_scope = PrivacySetting::PRIVATE
	  	@post.save
	  	@post.has_permission_with?(@other_user).should be_false	
  	end
  end
end
