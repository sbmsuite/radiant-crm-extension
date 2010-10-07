# radiant-crm-extension
# Copyright (C) 2008-2009 by Michael Dvorkin
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#------------------------------------------------------------------------------

# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/fat_free_crm/version"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/fat_free_crm/core_ext"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/fat_free_crm/permissions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/fat_free_crm/tabs"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/fat_free_crm/callback"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/fat_free_crm/plugin"

require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/crm/helper_extensions/application_helper_extensions"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/crm/model_extensions/user_model_extension"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/crm/controller_extensions/application_controller_extension"
require_dependency "#{File.expand_path(File.dirname(__FILE__))}/lib/crm/controller_extensions/pages_controller_extension"

class CrmExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/crm"
  
  def activate
    tab 'CRM' do
      #add_item "Dashboard", "/admin/home"
      add_item "Tasks", "/admin/tasks"
      add_item "Campaigns", "/admin/campaigns"
      add_item "Leads", "/admin/leads"
      add_item "Accounts", "/admin/accounts"
      add_item "Contacts", "/admin/contacts"
      add_item "Opportunities", "/admin/opportunities"
    end
    
    modify_classes
  end

  def modify_classes
    # Send all of the Vhost extensions and class modifications 
    ActionView::Base.send(:include, FatFreeCRM::Callback::Helper)
    ActionController::Base.send(:include, FatFreeCRM::Callback::Helper)
    ActiveRecord::Base.send(:include, FatFreeCRM::Permissions)

    User.send(:include, Crm::UserModelExtension)
    ApplicationController.send(:include, Crm::ApplicationControllerExtension)
    Admin::PagesController.send(:include, Crm::PagesControllerExtension)

    #ApplicationController.class_eval{ include Crm::ApplicationExt }
  end
end
