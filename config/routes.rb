ActionController::Routing::Routes.draw do |map|
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