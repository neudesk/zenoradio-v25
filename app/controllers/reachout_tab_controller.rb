class ReachoutTabController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_user
  
  DEFAULT_CALL_TIME = "default"
  DEFAULT_DAY_BETWEEN_CALLS = "3"
  DIAL_METHOD = "alcazar"
  NUMBER_OF_CHANNELS = "50"
  
  def index
    @stations = current_user.stations
    gateway_id = params[:gateway_id].present? ? params[:gateway_id] : nil
    @dids = gateway_id.present? ? DataEntryway.where(:gateway_id =>gateway_id) : []
    if gateway_id.present? 
      @campaigns_length = ReachoutTabCampaign.where(:gateway_id => gateway_id).length
      @campaigns = ReachoutTabCampaign.where(:gateway_id => gateway_id).page(params[:page]).per(10) 
      @last_called = @campaigns.last
      @listeners_length = get_listeners(gateway_id).length
    end
    
  end
  
  def save
    call_time = AdminSetting.find_by_name("Call Time").present? ? AdminSetting.find_by_name("Call Time").value : DEFAULT_CALL_TIME
    if params[:schedule_type] == "send_now"
      call_time_period = GoAutoDial.get_call_time.detect{|c_t| c_t["id"] == call_time }
      time = Time.parse(params[:schedule_hour]).strftime("%H%M").to_i
      start,stop = call_time_period["ct_default_start"].to_i,call_time_period["ct_default_stop"].to_i
      if time > start && time < stop
        schedule_start_date = DateTime.parse(DateTime.now.strftime("%Y-%m-%d #{Time.parse(params[:schedule_hour]).strftime("%H:%M")}"))
        schedule_end_date = schedule_start_date
        call_time = add_call_time(schedule_start_date)
      else
        redirect_to reachout_tab_index_path(:gateway_id =>  params[:gateway_id]), :alert => "Campaign cannot be sent.Time interval to can send campaign is #{start}-#{stop}.Please schedule this campaign to another date"
        return
      end
    else
      if DateTime.parse(params[:schedule_date]) > DateTime.now
        schedule_start_date = DateTime.parse(params[:schedule_date])
        schedule_end_date = DateTime.parse(params[:schedule_date])
        call_time = add_call_time(schedule_start_date)
      else
        redirect_to reachout_tab_index_path(:gateway_id =>  params[:gateway_id]), :alert => "Please select a future date."
      end
    end
    
    reachout_tab_campaign = ReachoutTabCampaign.new
    reachout_tab_campaign.gateway_id = params[:gateway_id]
    reachout_tab_campaign.did_e164 = params[:data_entryway]
    reachout_tab_campaign.generic_prompt = true
    reachout_tab_campaign.prompt = params[:prompt]
    reachout_tab_campaign.schedule_start_date = schedule_start_date
    reachout_tab_campaign.schedule_end_date = schedule_end_date
    reachout_tab_campaign.status = (schedule_start_date.strftime("%Y-%m-%d") == DateTime.now.strftime("%Y-%m-%d")) ? true : false
    reachout_tab_campaign.created_by = current_user.id

    if reachout_tab_campaign.save
      gateway_name = DataGateway.find(params[:gateway_id]).title 
      dial_method = DIAL_METHOD
      
      num_channels = NUMBER_OF_CHANNELS
      
      #for local mode use  
      if request.host == "localhost"
        wavfile = "http://207.41.170.89/system/reachout_tab_campaigns/prompts/000/000/035/original/Radiolaluzdecristop1.wav"
      else
        wavfile = "http://#{request.host}" + reachout_tab_campaign.prompt.url(:original, timestamp: false)
      end
      if request.host == "localhost"
        generic_prompt = "http://207.41.170.89/system/reachout_tab_campaigns/prompts/000/000/001/original/India9Jan.wav"
      else
        if DefaultPrompt.first.present?
          generic_prompt = "http://#{request.host}" + DefaultPrompt.first.prompt.url(:original, timestamp: false)
        else
          generic_prompt = "http://207.41.170.89/system/reachout_tab_campaigns/prompts/000/000/001/original/India9Jan.wav"
        end
      end
      Delayed::Job.enqueue SendCampaignsJob.new(reachout_tab_campaign.id,reachout_tab_campaign.gateway_id,
        schedule_start_date,
        "#{gateway_name}-#{params[:gateway_id]}",
        call_time,
        wavfile, 
        dial_method,
        params[:data_entryway],
        num_channels,
        reachout_tab_campaign.status == true ? "1" : "0",
        generic_prompt
      )
      
      if reachout_tab_campaign.present?
        redirect_to reachout_tab_index_path, :notice => "Campaign saved."
      else
        reachout_tab_campaign.destroy
        redirect_to reachout_tab_index_path(:gateway_id =>  params[:gateway_id]), :alert => "No active listeners for current gateway."
      end
    else
      if reachout_tab_campaign.errors.messages[:prompt].present?
        redirect_to reachout_tab_index_path(:gateway_id =>  params[:gateway_id]), :alert => "Campaign not saved. Please upload a valid wav file."
      else
        redirect_to reachout_tab_index_path(:gateway_id =>  params[:gateway_id]), :alert => "Something went wrong."
      end
    end
  end
  # GoAutoDial Campaign
  def add_call_time(start_call_time)
    call_time = AdminSetting.find_by_name("Call Time").present? ? AdminSetting.find_by_name("Call Time").value : DEFAULT_CALL_TIME
    call_time_period = GoAutoDial.get_call_time.detect{|c_t| c_t["id"] == call_time }
    stop = call_time_period["ct_default_stop"].to_i
    
    r = Random.new
    random_nr = r.rand(1..99999)
    call_time_id = random_nr.to_s + "-" + start_call_time.strftime("%-I%p")
    call_time_name = start_call_time.strftime("%-I%p")
    call_time = start_call_time.strftime("%H%M")
    end_call_time = stop
    all_call_time =  GoAutoDial.get_call_time.detect {|c| c['ct_default_start'] == start_call_time}
    GoAutoDial.add_call_time(call_time_id, call_time_name, call_time, end_call_time) if !all_call_time.present?
    all_call_time.present? ? all_call_time['id'] : call_time_id
  end
  

  
  def get_listeners(gateway_id)
    results = []
    days_between_calls = AdminSetting.find_by_name("Days between calls").present? ? AdminSetting.find_by_name("Days between calls").value : DEFAULT_DAY_BETWEEN_CALLS
    
    sql = "SELECT rtmg.ani_e164 from reachout_tab_listener_minutes_by_gateway as rtmg where rtmg.gateway_id = #{gateway_id} and rtmg.ani_e164 NOT IN
          ( Select phone_number from admin_dnc_list) and rtmg.ani_e164 NOT IN 
          (Select phone_number from reachout_tab_campaign_listener where date(campaign_date)> '#{(DateTime.now-days_between_calls.to_i.days).strftime("%Y-%m-%d")}') 
                        and rtmg.ani_e164 != '' and length(rtmg.ani_e164) = 11"
    listeners = ActiveRecord::Base.connection.execute(sql).to_a

    # GoAutodial cannot accept phone numbers with country code 
    # remove country code from phone number if phone number is 11 digit format
    # 19173412582 => 9173412582
    listeners.each do  |listener|
      results << listener[0].to_s.slice(0,10) if listener[0].to_s.slice!(0) == "1"
    end
    results
  end
  
  def destroy_campaign
    if params[:id]
      GoAutoDial.delete_campaign(params[:id])
      ReachoutTabCampaign.find(params[:id]).destroy
      ReachoutTabCampaignListener.delete_all(:campaign_id => params[:id])
      redirect_to :back , :notice => "Campaign deleted."
    else
      redirect_to :back , :alert => "Delete campaign failed."
    end
  end
  
  protected
  def validate_user
    # TODO Check if Reachout Tab is enabled for current BRD
    if current_user.is_broadcaster? 
      is_active = DataGroupBroadcast.joins(:sys_users).where("sys_user.id=?",current_user.id).select("data_group_broadcast.reachout_tab_is_active")
      is_active = is_active[0].present? ? is_active[0].reachout_tab_is_active : false
      redirect_to root_path if !is_active
    elsif current_user.is_rca? 
      is_active = DataGroupRca.joins(:sys_users).where("sys_user.id=?",current_user.id).select("data_group_rca.reachout_tab_is_active")
      is_active = is_active[0].present? ? is_active[0].reachout_tab_is_active : false
      redirect_to root_path if !is_active
    end
  end
end
