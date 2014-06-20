class DataGroupBroadcast < ActiveRecord::Base
  attr_accessible :title
  has_many :data_gateways, foreign_key: :broadcast_id
  has_many :gateways, class_name: "DataGateway", foreign_key: :broadcast_id
  has_many :data_contents, foreign_key: :broadcast_id
  has_many :sys_user_resource_broadcasts, foreign_key: :broadcast_id
  has_many :sys_users, through: :sys_user_resource_broadcasts, source: :user
  # has_many :summary_sessions_by_gateways, foreign_key: :broadcast_id

  # SHARED METHODS
  include ::SharedMethods
  attr_accessible :title, :reachout_tab_is_active
  accepts_nested_attributes_for :data_gateways
  validates_presence_of :title

  def refresh_gateways(selected_ids)
    self.gateways.update_all(broadcast_id: nil)
    return true unless selected_ids.present?
    selected_ids.each do |selected_id|
      gateway = DataGateway.find_by_id(selected_id)
      gateway.update_attributes(broadcast_id: id)
    end
  end
end

# == Schema Information
#
# Table name: data_group_broadcast
#
#  id         :integer          not null, primary key
#  title      :string(200)
#  is_deleted :boolean          default(FALSE)
#

