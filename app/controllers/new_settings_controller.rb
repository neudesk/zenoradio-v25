class NewSettingsController < ApplicationController
  before_filter :set_station, except: [:index]
  def index
    @stations = current_user.stations
    @q = @stations.search(params[:q])
    @stations = @q.result(distinct: true).page(params[:page]).per(12)
    if @stations.total_pages < params[:page].to_i
      params[:page] = 1
      @stations = @q.result(distinct: true).page(params[:page]).per(12)
    end
    @page = params[:page] || 1
    @new_station = DataGateway.new
    @new_extension = DataContent.new
    if params[:station_id].present?
      @station = DataGateway.find_by_id(params[:station_id])
      if @station.present?
        if @stations.include?(@station)
          @extensions =  @station.data_gateway_conferences
          @phone_numbers = @station.data_entryways
          @prompts = @station.prompts
          @prompt = DataGatewayPrompt.new
        else
          @station = nil
        end
      end
    end
  end

  def show
    @streams =  @station.data_contents
    @phone_numbers = @station.data_entryways
  end

  def set_station
    @station = current_user.stations.find_by_id(params[:id])
    redirect_to root_url, alert: "Not Authorized." unless @station.present?
  end

end
