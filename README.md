privacy_setting
===============

A Ruby gem that add Privacy Settings to RoR application quickly and easily

1. Update your Gemfile
In order to use the Privacy Setting module, add the following gem to your Gemfile in Rails application
gem 'privacy_setting', :git => 'https://github.com/xuanchien/privacy_setting'

2. How to use?
2.1 Migration
Run the following command to install the necessary files for privacy setting function
rails g privacy_setting
And then run rake db:migrate to add new table to your database. This table is called ps_setting by default and it contains all 
the setting in your application.
There are two special modules in privacy_setting gem that help you manage the privacy setting. They are UserPermission and ObjectPermission.
a. UserPermission
This module has to be included in your user model. After including this module, your module will be able to set and get
the privacy setting on particular section of your website
b. ObjectPermission
To be added later
