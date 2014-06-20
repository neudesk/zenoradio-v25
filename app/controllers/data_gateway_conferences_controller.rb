class DataGatewayConferencesController < ApplicationController
  respond_to :js, :html
  def edit
    @conference = DataGatewayConference.find_by_id(params[:id])
  end

  def update
    flash[:hash] = "extensions"
    @conference = DataGatewayConference.find_by_id(params[:id])
    @content = @conference.content
    old_url = @content.media_url
    old_backup = @content.backup_media_url
    old_name = @content.title
    old_extension = @conference.extension

    if @conference.update_attributes(params[:data_gateway_conference])
      @content = @conference.content
      new_url = @content.media_url
      new_backup = @content.backup_media_url
      new_name = @content.title
      new_extension = @conference.extension

      if old_url == new_backup && old_backup == new_url
        @content.create_activity key: 'data_content.switch_stream', owner: current_user, trackable_title: @content.title, user_title: user_title, parameters: {old_url: old_url, new_url: new_url, channel_no: new_extension}
      elsif old_url != new_url
        @content.create_activity key: 'data_content.change_stream_url', owner: current_user, trackable_title: @content.title, user_title: user_title, parameters: {old_url: old_url, new_url: new_url, channel_no: new_extension}
      end
      @content.create_activity key: 'data_content.change_name', owner: current_user, trackable_title: @content.title, user_title: user_title, parameters: {old_url: old_url, new_url: new_url, channel_no: new_extension} if old_name != new_name
      @conference.gateway.create_activity key: 'data_gateway.move_content', owner: current_user, parameters: {extension_id: @conference.id, content_id: @content }, trackable_title: @conference.gateway.title, user_title: user_title, sec_trackable_title: @content.title, sec_trackable_type: 'DataContent' if old_extension != new_extension
      redirect_to :back, notice: "Successfully updated extension details."
    else
      redirect_to :back, error: "Error Occured. Please contact System Administrator."
    end
  end

  def switch
    @conference = DataGatewayConference.find_by_id(params[:id])
    content = @conference.content
    old_url = content.media_url
    new_url = content.backup_media_url
    if content.update_attributes(media_url: new_url, backup_media_url: old_url)
      content.create_activity key: 'data_content.switch_stream', owner: current_user, trackable_title: content.title, user_title: user_title, parameters: {old_url: old_url, new_url: new_url, channel_no: @conference.extension}
      redirect_to :back, notice: "Successfully switched media and backup URLs."
    else
      redirect_to :back, notice: "Error Occured. Please contact System Administrator."
    end
  end
end