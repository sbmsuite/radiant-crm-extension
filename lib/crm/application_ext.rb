module Crm::ApplicationExt
  ApplicationController.methods_after_set_javascripts_and_stylesheets << :add_inline_crm_files
 
  def add_inline_crm_files
    @stylesheets << 'grids'
    @stylesheets << 'crm/screen'
    @stylesheets << 'crm/facebox.css'
    @stylesheets << 'crm/colors'
    @stylesheets << 'crm'
    @stylesheets << 'crm/overrides'
    @javascripts << 'facebox'
    @javascripts << 'crm_application'
    @javascripts << 'crm_classes'

  end  
end
