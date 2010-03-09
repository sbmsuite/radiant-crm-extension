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
  
   define_routes do |map|

	  map.create_lead 'leads/create_lead', :controller => 'leads', :action => 'create_lead'

    map.with_options(:controller => 'admin/accounts') do |account|
     account.options 'admin/accounts/options', :action => 'options'
     account.redraw  'admin/accounts/redraw', :action => 'redraw'
     account.search 'admin/accounts/search', :action => 'search'
    end

    map.with_options(:controller => 'admin/campaigns') do |campaign|
     campaign.options 'admin/campaigns/options', :action => 'options'
     campaign.redraw  'admin/campaigns/redraw', :action => 'redraw'
     campaign.search  'admin/campaigns/search', :action => 'search'
     campaign.filter  'admin/campaigns/filter', :action => 'filter'
    end

    map.with_options(:controller => 'admin/contacts') do |contact|
     contact.options 'admin/contacts/options', :action => 'options'
     contact.redraw  'admin/contacts/redraw', :action => 'redraw'
     contact.search 'admin/contacts/convert', :action => 'convert'
    end

    map.with_options(:controller => 'admin/home') do |home|
     home.toggle 'admin/home/toggle', :action => 'toggle'
     home.options 'admin/home/options', :action => 'options'
     home.redraw  'admin/home/redraw', :action => 'redraw'
     home.toggle 'admin/home/toggle', :action => 'toggle'
     home.timezone 'admin/home/timezone', :action => 'timezone'
    end

    map.with_options(:controller => 'admin/leads') do |lead|
     lead.options 'admin/leads/options', :action => 'options'
     lead.redraw  'admin/leads/redraw', :action => 'redraw'
     lead.convert 'admin/leads/convert', :action => 'convert'
     lead.reject 'admin/leads/reject', :action => 'reject'
     lead.search 'admin/leads/search', :action => 'search'
     lead.filter 'admin/leads/filter', :action => 'filter'
    end

    map.with_options(:controller => 'admin/opportunities') do |opportunity|
     opportunity.options 'admin/opportunities/options', :action => 'options'
     opportunity.redraw  'admin/opportunities/redraw', :action => 'redraw'
     opportunity.search  'admin/opportunities/search', :action => 'search'
     opportunity.filter  'admin/opportunities/filter', :action => 'filter'
    end

    map.with_options(:controller => 'admin/tasks') do |task|
     task.complete 'admin/tasks/complete/:id', :action => 'complete'
     task.filter 'admin/tasks/filter', :action => 'filter'
    end

    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :home
      admin.resources :tasks,         :has_many => :comments, :member => { :complete => :put }
      admin.resources :comments
      admin.resources :leads,         :has_many => :comments, :collection => { :search => :get, :auto_complete => :post, :options => :get, :redraw => :post }, :member => { :convert => :get, :promote => :put, :reject => :put }

      admin.resources :opportunities, :has_many => :comments, :collection => { :search => :get, :auto_complete => :post, :options => :get, :redraw => :post }

      admin.resources :campaigns,     :has_many => :comments, :collection => { :search => :get, :auto_complete => :post, :options => :get, :redraw => :post }

      admin.resources :accounts,      :has_many => :comments, :collection => { :search => :get, :auto_complete => :post, :options => :get, :redraw => :post }

      admin.resources :contacts,      :has_many => :comments, :collection => { :search => :get, :auto_complete => :post, :options => :get, :redraw => :post }
    end

  end
  
  def activate
    admin.nav << Radiant::AdminUI::NavTab.new(:crm, "CRM", [:crm, :free_crm])
    #admin.nav[:crm] << admin.nav_item(:dashboard, "Dashboard", "/admin/home")
    admin.nav[:crm] << admin.nav_item(:tasks, "Tasks", "/admin/tasks")
    admin.nav[:crm] << admin.nav_item(:campaigns, "Campaigns", "/admin/campaigns")
    admin.nav[:crm] << admin.nav_item(:leads, "Leads", "/admin/leads")
    admin.nav[:crm] << admin.nav_item(:accounts, "Accounts", "/admin/accounts")
    admin.nav[:crm] << admin.nav_item(:contacts, "Contacts", "/admin/contacts")
    admin.nav[:crm] << admin.nav_item(:opportunites, "Opportunities", "/admin/opportunities")
  

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
