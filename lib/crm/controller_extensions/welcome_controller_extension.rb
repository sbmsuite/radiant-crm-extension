module Crm::WelcomeControllerExtension
  def self.included(base)
    base.class_eval { 
      def index
        redirect_to admin_tasks_url
      end
    }
  end
end

