class LeadsController < ApplicationController
	skip_before_filter :verify_authenticity_token

  def create_lead
    user = current_site.users.first(:conditions => {:site_admin => true})
    params[:lead]['access'] = 'Private'
    params[:lead][:user_id] = user.id
    params[:lead][:site_id] = current_site.id
    @lead = Lead.new(params[:lead])

    respond_to do |format|
      if @lead.save_with_permissions(params)
        Comment.create(
          :commentable_type => "Lead",
          :comment => "#{@lead.first_name} #{@lead.last_name} said: \n #{params[:message]}",
          :commentable_id => @lead.id,
          :user_id => user.id
        )
        format.html { redirect_to "http://#{current_site.hostname}/Thanks" }
        format.xml  { render :xml => @lead, :status => :created, :location => @lead }
      else
        format.html { redirect_to "http://#{current_site.hostname}/Sorry" }
        format.xml  { render :xml => @lead.errors, :status => :unprocessable_entity }
      end
    end    
  end

end
