class SendCampaignsJob < Struct.new(:reachout_tab_campaign_id, :gateway_id, :schedule_start_date, :name,:call_time, :wavfile, :dial_method,:did, :num_channels, :active, :dnc_file)
  def perform
    p "******************************************************"
    p "----------------- Send Campaigns---------------------"
    p "******************************************************"

    days_between_calls = AdminSetting.find_by_name("Days between calls").present? ? AdminSetting.find_by_name("Days between calls").value : 3
    results = []
    listener_list = []
    sql = "SELECT rtmg.ani_e164 from reachout_tab_listener_minutes_by_gateway as rtmg where rtmg.gateway_id = #{gateway_id} and rtmg.ani_e164 NOT IN
          ( Select phone_number from admin_dnc_list) and rtmg.ani_e164 NOT IN 
          (Select phone_number from reachout_tab_campaign_listener where date(campaign_date)> '#{(DateTime.now - days_between_calls.to_i.days).strftime("%Y-%m-%d")}') 
                        and rtmg.ani_e164 != '' and length(rtmg.ani_e164) = 11"
    listeners = ActiveRecord::Base.connection.execute(sql).to_a
    listeners.length
    # GoAutodial cannot accept phone numbers with country code 
    # remove country code from phone number if phone number is 11 digit format
    # 19173412582 => 9173412582
    listeners.each do  |listener|
      listener_list << "(#{gateway_id} ,#{reachout_tab_campaign_id},#{listener[0].to_s},'#{DateTime.parse(schedule_start_date.to_s).to_s(:db)}', '#{Time.now.to_s(:db)}' )" if listener[0].chars.first == "1"
      results << listener[0].to_s.slice(0,10) if listener[0].to_s.slice!(0) == "1"
    end
    if results.present?
      # GoAutodial cannot accept phone numbers with country code 
      GoAutoDial.add_campaign(reachout_tab_campaign_id,name,call_time,wavfile,dial_method,results.join(','), did, num_channels, active, dnc_file)

      if listener_list.present?
        sql = "INSERT INTO reachout_tab_campaign_listener(gateway_id,campaign_id, phone_number, campaign_date, created_at) Values #{listener_list.join(',')}"
        ActiveRecord::Base.connection.execute(sql)
      end
    end
    p "******************************************************"
    p "-----------------END Send Campaigns-------------------"
    p "******************************************************"

  end
end
