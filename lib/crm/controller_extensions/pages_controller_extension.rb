module Crm::PagesControllerExtension
  def self.included(base)
    base.send  :only_allow_access_to, :index, :show, :new, :create, :edit, :update, :remove, :destroy, \
      :when => [:admin, :designer, :free_designer], 
      :denied_url => { :controller => 'tasks', :action => 'index' },
      :denied_message => "You don't have permission to access this page"
  end
end

