class CreatePsSettingsTable < ActiveRecord::Migration
	def self.up 
		create_table :ps_settings, :force => true do |t|
			t.string :rule_name
			t.integer :scope
			t.integer :user_id
			t.string :object_value

			t.timestamps
		end

		add_index :ps_settings, [:rule_name, :user_id, :object_value], :name => "settings_rule_user_object_value", :unique => true
		add_index :ps_settings, [:rule_name, :user_id], :name => "setting_rule_user", :unique => false
		add_index :ps_settings, :user_id
		add_index :ps_settings, :rule_name
	end

	def self.down
		drop_table :ps_settings
	end
end