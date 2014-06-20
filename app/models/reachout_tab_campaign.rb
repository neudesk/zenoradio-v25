class ReachoutTabCampaign < ActiveRecord::Base
  attr_accessible :gateway_id, :prompt, :did_e164, :generic_prompt, :schedule_end_date, :schedule_start_date, :campaign_id, :status, :data_gateway_attributes
  
  validates :gateway_id , :presence => true
  validates :did_e164 , :presence => true
  validates :schedule_start_date , :presence => true
  validates :schedule_end_date , :presence => true
  
  has_attached_file :prompt, :presence => true
  belongs_to :data_gateway, foreign_key: :gateway_id
  accepts_nested_attributes_for :data_gateway
 
  validates_attachment_content_type :prompt, :content_type => ["audio/wav"]
end
