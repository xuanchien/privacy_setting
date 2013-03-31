module PrivacySetting
	module ObjectPermission
		extend ActiveSupport::Concern

		included do 
			after_save :save_privacy_scope
		end
		

		##
		#Each object will need to have an owner. This owner will be the one that change
		#the privacy scope on object. By default, return self.user field as owner
		def privacy_owner
			self.user
		end

		##
		#return the unique id to identify privacy setting for this object
		#by default, use the id field.
		#override this method if you want a custom id stored in setting data
		def privacy_object_id
			return self.id
		end

		##
		#Check to see if some user has permission on this object or not
		def has_permission_with?(user)
			return user.has_permission?(privacy_owner, self.class.privacy_rule_name, privacy_object_id)
		end

		##
		#get the privacy scope of this object
		def privacy_scope
			if @privacy_scope.nil?
				@privacy_scope = privacy_owner.get_privacy_scope(self.class.privacy_rule_name, privacy_object_id)
			end
			return @privacy_scope
		end

		##
		#set the privacy scope of this object
		def privacy_scope=(scope)
			@privacy_scope = scope
		end

	private
		def save_privacy_scope
			unless @privacy_scope.nil?
				privacy_owner.set_privacy_scope(self.class.privacy_rule_name, @privacy_scope, privacy_object_id)	
			end
		end

		module ClassMethods
			##
			#return the privacy rule name for this type of object
			#based on the model name
			def privacy_rule_name
				return "ps_#{self.model_name.downcase}"
			end
		end
	end
end