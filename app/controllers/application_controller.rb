class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  skip_after_filter :intercom_rails_auto_include
  protect_from_forgery
  layout :layout_by_resource
  before_filter :set_first_station
  before_filter :set_last_seen_at

  SEVEN_DAYS = 7
  TWENTY_FOUR_HOURS = 1
  SEVEN_DAYS_BY_HOURS = 8
  THIRTY_DAYS = 30
  SLIDER_SIZE = 6
  SLIDER_PAGE_SIZE = 18
  SLIDER_FIRST_PAGE_SIZE = 17

  def after_sign_in_path_for(user)
    # if user.valid_password?(user.default_password) || user.barcode.nil? || user.barcode.empty?
    if user.valid_password?(user.default_password)
      reset_password_users_path
    else
      root_url
    end
  end

  def thirdparty?
    current_user.is_thirdparty?
  end
  helper_method :thirdparty?

  def marketer?
    current_user.is_marketer?
  end
  helper_method :marketer?
  
  def layout_by_resource
    if devise_controller? || %w{reset_password submit_reset_password}.include?(params[:action])
      "login"
    elsif params[:controller] == "pending_users" && %w{new create save}.include?(params[:action])
      "framed"
    else
      "application"
    end
  end

  def get_stations
    if current_user
      if !params[:slider_search_enabled] || params[:slider_search_enabled] == "false"
        # @stations = current_user.stations if current_user # for slides.
        if current_user.is_marketer?
          @stations = current_user.stations.top_stations(current_user, {day: 1, limit: SLIDER_SIZE}) if current_user
        else
          @stations = current_user.stations
        end
        @station_id ||= @stations.try(:first).try(:id)

        if @station_id
          @station = DataGateway.find @station_id
        end

      else
        @slider_country_id = params[:country_id]
        @slider_rca_id = params[:rca_id]
        @slider_query = params[:query]
        @stations = current_user.stations.filter(@slider_query, @slider_country_id.to_i, @slider_rca_id.to_i, current_user)
      end
      @selected_station_id = params[:station_id]

    end
  end

  def slider_search
    session[:gateway_id] = ''
    country_id = params[:country_id]
    if current_user.is_marketer?
      rca_id = params[:rca_id]
    else 
      rca_id = ''
    end
    query = params[:query]
    current_page = params[:current_page].nil? ? 1 : params[:current_page]
    @stations = current_user.stations
    if query.present? || country_id.present? || rca_id.present?
      @stations = @stations.filter(query, country_id.to_i, rca_id.to_i, current_user)
    end    
    if @stations.nil? || @stations.empty?
      html_content = render_to_string partial: 'shared/slider_noresults'
      render :json => {:partial => html_content, :prev_enabled => false , :next_enabled => false}
    else
      first_station_id = @stations.present? && params[:controller_name] == '/settings' ? @stations.first.id : ''
      next_enabled = (current_page.to_i - 1) * SLIDER_PAGE_SIZE + SLIDER_PAGE_SIZE < @stations.length #current_page.to_i < total_pages
      prev_enabled = current_page.to_i > 1 && @stations.length > 18
      controller_name = ''
      controller_name = params[:controller_name] if (params[:controller_name] == "/settings" || params[:controller_name] == "/graphs" || params[:controller_name] == "/reports" || params[:controller_name] =="/reachout_tab")
      
      
      if current_page.to_i == 1 && controller_name != "/settings" && @stations.length > 1
        @stations = @stations.limit(SLIDER_FIRST_PAGE_SIZE).offset((current_page.to_i - 1) * SLIDER_FIRST_PAGE_SIZE ) 
      else
        @stations = @stations.limit(SLIDER_PAGE_SIZE).offset((current_page.to_i - 1) * SLIDER_PAGE_SIZE ) 
      end

      html_content = render_to_string partial: 'shared/slider_search', :locals => 
        {:stations => @stations,
        :country_id => country_id,
        :rca_id => rca_id, 
        :query => query,
        :gateway_id => params[:gateway_id],
        :first_station_id => first_station_id,
        :controller_name => controller_name,
        :current_page => current_page
      }
      render :json => {:partial => html_content, :prev_enabled => prev_enabled , :next_enabled => next_enabled}
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url
  end

  def convert_seconds_to_minutes(seconds)
    return (seconds.to_f / 1.minutes).round(2)
  end
  
  def user_title
    if current_user
      "#{current_user.title} (#{current_user.email})"
    end
  end

  protected

  def set_first_station
    if current_user
      get_first_station
      if @_stations.present?
        @stations = [@_stations.first]
      else
        @stations = DataGateway.new
      end
    end
  end
  
  def get_first_station
    if current_user
      country_id = params[:country_id]
      if current_user.is_marketer?
        rca_id = params[:rca_id]
      else 
        rca_id = ''
      end
      query = params[:query]
      @_stations = current_user.stations
      if query.present? || country_id.present? || rca_id.present?
        @_stations = @_stations.filter(query, country_id.to_i, rca_id.to_i, current_user)
      end
      if @_stations.present?
        @first_station = @_stations.first
      else
        @first_station = DataGateway.new
      end
    end
  end
  
  def set_last_seen_at
    if current_user && session[:session_activity_id]
      session_activity_id = session[:session_activity_id]
      public_activity = PublicActivity::Activity.find(session_activity_id) rescue nil
      if public_activity.present?
        time_period = Time.now - public_activity.created_at
        public_activity.parameters = { :time_period => time_period, :time => Time.now }
        public_activity.save
      end
    end
    
  end 
  #
  def hostname
    request.protocol + request.host_with_port
  end
  helper_method :hostname
  
end
