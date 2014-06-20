class DataGatewayPromptsController < ApplicationController
  before_filter :authenticate_user!

  def create
    flash[:hash] = "prompts"
    @prompt = DataGatewayPrompt.new(params[:data_gateway_prompt])
    @prompt.build_data_gateway_prompt_blob

    data = DataGatewayPrompt::convert_uploaded_audio(@prompt.raw_audio)


    if data.status == DataGatewayPrompt::CONVERT_OK
      @prompt.media_kb = data.media_kb
      @prompt.media_seconds = data.duration
      @prompt.date_last_change = Time.now
      @prompt.data_gateway_prompt_blob.binary = data

      if @prompt.save
        station = @prompt.data_gateway
        station.create_activity key: 'data_gateway.create_prompt', owner: current_user,
            trackable_title: station.title, user_title: user_title, parameters: {:prompt_id => @prompt.id },
            sec_trackable_title: @prompt.title, sec_trackable_type: 'DataGatewayPrompt'
        redirect_to :back, notice: "Successfully created a new prompt."
      else
        redirect_to :back, alert: "Error Occured. Please contact System Administrator."
      end
    else
      redirect_to :back, alert: "Invalid audio format. Ony wav/mp3 format is supported"  
    end
  end
end