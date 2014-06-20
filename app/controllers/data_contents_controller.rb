class DataContentsController < ApplicationController
  before_filter :authenticate_user!
  
  def edit
    @data_content = DataContent.find(params[:id])
    @content_query = params[:content_query]
    respond_to do |format|
      format.js
    end
  end

  def update
    @data_content = DataContent.find(params[:id])    
    old_url = @data_content.media_url
    old_backup = @data_content.backup_media_url
    old_name = @data_content.title
      
    success_update = @data_content.update_attributes(params[:data_content])
    
    new_name = @data_content.title
    new_url = @data_content.media_url
    new_backup = @data_content.backup_media_url
      
    if success_update
      p @data_content.data_gateway_conferences[0].extension
      if old_name != new_name
        @data_content.create_activity key: 'data_content.change_name', owner: current_user, trackable_title: @data_content.title, user_title: user_title,
          parameters: {:old_name => old_name, :new_name => new_name, :channel_no => @data_content.data_gateway_conferences[0].extension}
      end
      if old_url == new_backup && old_backup == new_url
        @data_content.create_activity key: 'data_content.switch_stream', owner: current_user, user_title: user_title,
          trackable_title: @data_content.title, parameters: {:old_url =>old_url, :new_url => new_url, :channel_no => @data_content.data_gateway_conferences[0].extension} 
      elsif old_url != new_url
        @data_content.create_activity key: 'data_content.change_stream_url', owner: current_user, trackable_title: @data_content.title, user_title: user_title,
          parameters: {:old_url =>old_url, :new_url => new_url, :channel_no => @data_content.data_gateway_conferences[0].extension}
      end
      
      redirect_to search_content_search_path(:content_query => params[:content_query]), notice: "Your content has been updated."
    else
      flash[:error] =  "<ul>" + @data_content.errors.messages.values.map { |o| o.map{|p| "<li>"+p+"</li>"}.join(" ") }.join(" ") + "</ul>"
      flash[:error] = flash[:error] + "<ul><li>Your content was unsuccessfully updated.</li></ul>"
    end    
  end
  
  def show
    @data_content = DataContent.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def destroy
    data_content = DataContent.find(params[:id])
    if data_content.is_deleted
      redirect_to search_content_search_path(:content_query => params[:content_query]), notice: "Your content has been deleted."
    else
      success_delete = data_content.update_attribute(:is_deleted, true)
      data_content.create_activity key: 'data_content.destroy', owner: current_user, trackable_title: data_content.title, user_title: user_title, 
        parameters: {:content_id => data_content.id, :media_url => data_content.media_url, :channel_no => @data_content.data_gateway_conferences[0].extension}
      if success_delete
        data_gateway_conference = DataGatewayConference.where(:content_id => params[:id])
        if data_gateway_conference.present?
          data_gateway_conference.each do |dgc|
            dgc.destroy 
          end
        end
        
        redirect_to search_content_search_path(:content_query => params[:content_query]), notice: "Your content was successfully deleted."
      else
        flash[:error] =  "<ul>" + data_content.errors.messages.values.map { |o| o.map{|p| "<li>"+p+"</li>"}.join(" ") }.join(" ") + "</ul>"
        flash[:error] = flash[:error] + "<ul><li>Your content was unsuccessfully deleted.</li></ul>"
        redirect_to search_content_search_path(:content_query => params[:content_query])
      end
    end
  end

  def suggestion
    if params[:query].present?
      results = DataContent.where("media_url LIKE :key", key: "%#{params[:query].strip}%").limit(10)
    else
      results = DataContent.limit(10)
    end
    final = results.collect{|x| {id: x.id, name: x.media_url}}
    render json: final.to_json
  end

 
end
