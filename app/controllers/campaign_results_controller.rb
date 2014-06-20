class CampaignResultsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_user
  
  def index
    if current_user.is_rca?
      user_stations = current_user.stations
      @gateways = DataGateway.joins(:reachout_tab_campaigns).select("data_gateway.id, data_gateway.title").where("data_gateway.id in(#{user_stations.map(&:id).join(',')})").uniq.page(params[:page]).per(15)
    else
      @gateways = DataGateway.joins(:reachout_tab_campaigns).select("data_gateway.id, data_gateway.title").uniq.page(params[:page]).per(15)
    end
    
  end
  
  def get_campaigns_by_gateway_id
    limit = 10
    current_page = params[:page].present? ? params[:page].to_i : 1
    offset = (current_page.to_i * limit) - limit
    campaign_count = ReachoutTabCampaign.select("count(*) as campaigns_count").where(:gateway_id => params[:gateway_id]).first.campaigns_count
    sql = "SELECT data_gateway.title, reachout_tab_campaign.* FROM `reachout_tab_campaign` 
            INNER JOIN `data_gateway` ON `data_gateway`.`id` = `reachout_tab_campaign`.`gateway_id` 
            WHERE reachout_tab_campaign.gateway_id = #{params[:gateway_id]} limit #{offset}, #{limit}"
    
    campaigns = ActiveRecord::Base.connection.execute(sql).to_a
    page_no = campaign_count > 10 ? (campaign_count / 10.0).ceil : 1

    render :partial => "campaign_results/campaigns", :locals => {:campaigns => campaigns,
      :gateway_id => params[:gateway_id],
      :page_no =>page_no,
      :current_page => current_page
    }
  end
  
  def destroy_campaign
    if params[:id].present?
      GoAutoDial.delete_campaign(params[:id])
      ReachoutTabCampaign.find(params[:id]).destroy
      ReachoutTabCampaignListener.delete_all(:campaign_id => params[:id])
      redirect_to :back , :notice => "Campaing deleted."
    else
      redirect_to :back , :alert => "Delete campaign failed."
    end
  end
  
  def get_campaign_status
    campaign_status = GoAutoDial.get_campaign_status(params[:campaign_id])
    render :partial => "campaign_status", :locals => {:camapaign_status => campaign_status}
  end
  protected
  def validate_user
    if current_user.is_rca? 
      is_active = DataGroupRca.joins(:sys_users).where("sys_user.id=?",current_user.id).select("data_group_rca.reachout_tab_is_active")
      is_active = is_active[0].present? ? is_active[0].reachout_tab_is_active : false
      redirect_to root_path if !is_active
    elsif current_user.is_broadcaster?
      redirect_to root_path
    end
  end
end