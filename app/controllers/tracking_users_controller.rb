class TrackingUsersController < ApplicationController
  before_filter :authenticate_user!
  
  def index
     @activity_query = params[:activity_query]
     @activity_type = params[:activity_type]
     where = ''
     if @activity_query
       where = "(trackable_title like '%#{@activity_query}%' OR user_title like '%#{@activity_query}%' OR sec_trackable_title like '#{@activity_query}%')"       
     end
     unless @activity_type.blank?
       unless where.blank?
          where += ' AND '
       end
       case @activity_type
          when 'login'  
            where += "trackable_type like 'User'"
          when 'content'
            where += "trackable_type like 'DataContent'"
          else
            where += "(trackable_type like 'DataGateway' OR trackable_type like 'DataGatewayConference')"
        end             
     end    
     if where.blank?
        @activities = PublicActivity::Activity.order("created_at desc").page(params[:page]).per(10)
     else
       @activities = PublicActivity::Activity.where(where).order("created_at desc").page(params[:page]).per(10)
     end       
  end
  
end
