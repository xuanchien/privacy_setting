privacy_setting
===============

A Ruby gem that add Privacy Settings to RoR application quickly and easily

##Update your Gemfile
In order to use the Privacy Setting module, add the following gem to your Gemfile in Rails application
	gem 'privacy_setting', :git => 'https://github.com/xuanchien/privacy_setting'
You will need to run `bundle install` to update your Gemfile.lock

##How to use?
###Migrations
Run the following command to install the necessary files for this gem
	rails g privacy_setting
Update the database to the latest migration.
	rake db:migrate
This PrivacySetting module needs to store settings in database. By default, this table is called ps_setting 
###Privacy Scopes
There are three privacy scopes that is used in this Privacy Settings module, they are PUBLIC, FRIENDS_ONLY and PRIVATE. 
* PUBLIC: If a user sets a section to this scope, every other users will be able to view that section.
* FRIENDS_ONLY: If a user sets a section to this scope, only his friends will be able to view that section. You will need to implement a special method in your class to check for friend relationship
* PRIVATE: If a user sets a section to this scope, no one will be able to view that section except that user.
###Usage
There are two special modules in privacy_setting gem that can be integrated into your application. They are UserPermission and ObjectPermission.
####UserPermission
This module has to be included in your user model. 
	class User < ActiveRecord::Base
		include UserPermission
	end
After including this module, your module will be able to set and get the privacy setting on particular section of your website. Let's say you define a section called "user_profile" on your website. A certain user can set privacy setting for this section like this
	user.set_privacy_scope("user_profile", PrivacySetting::PRIVATE)
Another user can request to know if he has permission on this section or not
	other_user.has_permission?(user, "user_profile")
Depend on the relationship between `user` and `other_user`, the `has_permission?` method will return `true` or `false`.
A user can also query about the privacy scope that he set on a particular section using the `get_privacy_scope` method
	//return PrivacySetting::PUBLIC, PrivacySetting::FRIENDS_ONLY or PrivacySetting::PRIVATE
	user.get_privacy_scope("user_profile")
#####Ultimate permission
In some cases, you want some user to have special permission that they can view user's section no matter what privacy scope they set (for example, the Admin user). In order to achieve this, you need to implement the `always_has_permission?` method in user model. For example
	def always_has_permission?
		return true if admin?
	end
#####Friendship
The FRIENDS_ONLY scope will affect those users who are considered friends. You will need to implement the `friend_with?` method to check the friendship relationship between two users. By default, this method return `false`, you have to override it in your user model like this, for example
	def friend_with?(user)
		if user.id % 2 == 0 && id % 2 == 0
			return true
		else
			return false
		end
	end
In the above example, we use simple rule that two users will be friend if their id are both even ^_^.
####ObjectPermission
If you want the user to be able to set the privacy scope on particular kind of object, you will need to include this module in that object model. For example, you have a model called `Post` in your application and you want to allow any user to add the privacy scope for that object. Here is what you need to do:
	class Post < ActiveRecord::Base
		include ObjectPermission
	end
There is one rule you have to follow: each object must have its owner. By default, only the object owner can set privacy setting for that object. For example:
	post = Post.new
	post.set_privacy_scope(PrivacySetting::PUBLIC)
The above code will set the privacy setting of `post` to PUBLIC. 
Any user can check for permission on this particular object by using the method `has_permission_with?` on that object. For example
	//return true or false
	post.has_permission_with?(user)
#####Object Owner
When using Privacy Setting module, each object has to be owned by an user in order to set witht the privacy scope. By default, the `user` property in object model will be used as the privacy owner. You can override this method in your model
	def privacy_owner
		//return the owner of this object
	end
Notice that the object returned from this method has to be the model that already includes `UserPermission` module
#####Object Id
In order to identify each object, we use the `id` property on that object to store in setting table. If you want to identify through other property, you can override the `privacy_object_id` method
	def privacy_object_id
		//return an id that uniquely identified this object
	end

##Credits
Author: Chien Tran
Contributors: You are welcome

##License
Copyright (c) 2013
Licensed under the MIT license (see MIT-LICENSE file)