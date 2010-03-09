module Crm
  module ApplicationControllerExtension
    def self.included(base)
      base.class_eval {
        helper_method :called_from_index_page?, :called_from_landing_page?

        #----------------------------------------------------------------------------
        def can_signup?
          [ :allowed, :needs_approval ].include? Setting.user_signup
        end

        #----------------------------------------------------------------------------
        def called_from_index_page?(controller = controller_name)
          if controller != "tasks"
            request.referer =~ %r(/#{controller}$)
          else
            request.referer =~ /tasks\?*/
          end
        end

        #----------------------------------------------------------------------------
        def called_from_landing_page?(controller = controller_name)
          request.referer =~ %r(/#{controller}/\w+)
        end

        #----------------------------------------------------------------------------
        def update_recently_viewed
          subject = instance_variable_get("@#{controller_name.singularize}")
          if subject
            Activity.log(current_user, subject, :viewed)
          end
        end

        #----------------------------------------------------------------------------
        def respond_to_not_found(*types)
          asset = self.controller_name.singularize
          flick = case self.action_name
            when "destroy" then "delete"
            when "promote" then "convert"
            else self.action_name
          end
          if self.action_name == "show"
            flash[:warning] = "This #{asset} is no longer available."
          else
            flash[:warning] = "Can't #{flick} the #{asset} since it's no longer available."
          end
          respond_to do |format|
            format.html { redirect_to(:action => :index) }                         if types.include?(:html)
            format.js   { render(:update) { |page| page.reload } }                 if types.include?(:js)
            format.xml  { render :text => flash[:warning], :status => :not_found } if types.include?(:xml)
          end
        end

        #----------------------------------------------------------------------------
        def respond_to_related_not_found(related, *types)
          asset = self.controller_name.singularize
          asset = "note" if asset == "comment"
          flash[:warning] = "Can't create the #{asset} since the #{related} is no longer available."
          url = send("#{related.pluralize}_path")
          respond_to do |format|
            format.html { redirect_to(url) }                                       if types.include?(:html)
            format.js   { render(:update) { |page| page.redirect_to(url) } }       if types.include?(:js)
            format.xml  { render :text => flash[:warning], :status => :not_found } if types.include?(:xml)
          end
        end

        # Autocomplete handler for all core controllers.
        #----------------------------------------------------------------------------
        def auto_complete
          @query = params[:auto_complete_query]
          @auto_complete = hook(:auto_complete, self, :query => @query, :user => current_user)
          if @auto_complete.empty?
            @auto_complete = self.controller_name.classify.constantize.my(:user => current_user, :limit => 10).search(@query)
          else
            @auto_complete = @auto_complete.last
          end
          session[:auto_complete] = self.controller_name.to_sym
          render :template => "admin/common/auto_complete", :layout => nil
        end

        # Proxy current page for any of the controllers by storing it in a session.
        #----------------------------------------------------------------------------
        def current_page=(page)
          @current_page = session["#{controller_name}_current_page".to_sym] = page.to_i
        end

        #----------------------------------------------------------------------------
        def current_page
          page = params[:page] || session["#{controller_name}_current_page".to_sym] || 1
          @current_page = page.to_i
        end

        # Proxy current search query for any of the controllers by storing it in a session.
        #----------------------------------------------------------------------------
        def current_query=(query)
          @current_query = session["#{controller_name}_current_query".to_sym] = query
        end

        #----------------------------------------------------------------------------
        def current_query
          @current_query = params[:query] || session["#{controller_name}_current_query".to_sym] || ""
        end

      }
    end
  end
end
