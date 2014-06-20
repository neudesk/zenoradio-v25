class DataGroupRca < ActiveRecord::Base
  has_many :data_gateways, foreign_key: :rca_id
  has_many :sys_user_resource_rcas, foreign_key: :rca_id
  has_many :sys_users, through: :sys_user_resource_rcas, source: :user
  # has_many :summary_sessions_by_gateway, foreign_key: :rca_id
  attr_accessible :title, :reachout_tab_is_active

  has_many :gateways, class_name: "DataGateway", foreign_key: :rca_id

  # SHARED METHODS
  include ::SharedMethods
  accepts_nested_attributes_for :data_gateways
  validates_presence_of :title

  def refresh_gateways(selected_ids)
    self.gateways.update_all(rca_id: nil)
    return true unless selected_ids.present?
    selected_ids.each do |selected_id|
      gateway = DataGateway.find_by_id(selected_id)
      gateway.update_attributes(rca_id: id)
    end
  end
end

# == Schema Information
#
# Table name: data_group_rca
#
#  id         :integer          not null, primary key
#  title      :string(200)
#  is_deleted :boolean          default(FALSE)
#

