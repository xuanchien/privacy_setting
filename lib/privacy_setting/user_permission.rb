module PrivacySetting
	module UserPermission
		extend ActiveSupport::Concern

		##
		#Check to see if user has permission on certain ule of other user
		#
		def has_permission?(other_user, rule_name, object_value=nil)
			current_user = self

			if current_user.always_has_permission?
				return true
			end

			#owner always has permission on his own rule
			return true if current_user == other_user

			setting = PrivacySetting::Setting.find_with_object_value(rule_name, object_value)
				.where(:user_id => other_user.id).first

			if setting.nil?
				scope = PrivacySetting::DEFAULT_SCOPE
			else
				scope = setting.scope
			end

			if scope == PrivacySetting::PUBLIC
				return true
			elsif scope == PrivacySetting::FRIENDS_ONLY && current_user.friend_with?(other_user)
				return true
			else
				return false
			end
		end


		##
		#Save privacy settings
		#
		def set_privacy_scope(rule_name, scope, object_value=nil)
			setting = PrivacySetting::Setting.find_with_object_value(rule_name, object_value)
				.where(:user_id => self.id).first

			unless setting.nil?
				setting.scope = scope
				setting.save
			else
				setting = PrivacySetting::Setting.create(:rule_name => rule_name,
					:scope => scope, :user_id => self.id)
			end
		end

		def get_privacy_scope(rule_name, object_value=nil)
			setting = PrivacySetting::Setting.find_with_object_value(rule_name, object_value)
				.where(:user_id => self.id).first
			if setting.nil?
				return PrivacySetting::DEFAULT_SCOPE
			else
				return setting.scope
			end
		end

		##
		#override this method if you want to add more logic
		#for example: an admin should be able to has permission on every rules
		def always_has_permission?
			return false #no one has permission on everything
		end

		##
		#Check friend relationship, by default: no friend
		def friend_with?(user)
			return false
		end
	end
end