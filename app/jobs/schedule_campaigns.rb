class ScheduleCampaigns < Struct.new(:param)
  def perform  
    p "******************************************************"
    p "----------------- Schedule Campaigns---------------------"
    p "******************************************************"
    
    days_between_calls = AdminSetting.find_by_name("Days between calls").present? ? AdminSetting.find_by_name("Days between calls").value : 3
    
    GoAutoDial.get_dnc_list.each do |phone|
      AdminDncList.add_dnc_phone(phone["phone_number"])
    end
    
    past_campaigns = ReachoutTabCampaign.where("date(schedule_start_date) < '#{DateTime.now.strftime('%Y-%m-%d')}'")
    if past_campaigns.present?
      past_campaigns.each do |campaign|
        ReachoutTabCampaignListener.delete_all(:campaign_id => campaign.id) if campaign.schedule_start_date.strftime('%Y-%m-%d') == (DateTime.now - days_between_calls.to_i.days).strftime('%Y-%m-%d')
        if campaign.id.present?
          GoAutoDial.change_campaign_status(false,campaign.id)
          campaign.update_attribute("status", false)
        end
      end
    end
    
    current_day_campaigns = ReachoutTabCampaign.where("date(schedule_start_date) = '#{DateTime.now.strftime('%Y-%m-%d')}'")
    if current_day_campaigns.present?
      current_day_campaigns.each do |campaign|
        if campaign.id.present?
          GoAutoDial.change_campaign_status(true,campaign.id)
          campaign.update_attribute("status", true)
        end
      end
    end
    
    p "******************************************************"
    p "-------------- END Schedule Campaigns-----------------"
    p "******************************************************"
  end
end
