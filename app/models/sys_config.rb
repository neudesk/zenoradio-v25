class SysConfig < ActiveRecord::Base
  attr_accessible :group, :name, :value

  UI_CONFIG_GROUP = "UI_CONFIG"
  EMAIL_CONFIG = "EMAIL"

  def self.add_config(group, name, value)
    config = self.find_by_group_and_name(group, name)
    if config
      SysConfig.where(:group => "UI_CONFIG").where(:name => "EMAIL").update_all(:value => value)
    else
      SysConfig.create(group: group, name: name, value: value)
    end
  end

  def self.get_config(group, name)
    self.find_by_group_and_name(group, name)
  end
end

# == Schema Information
#
# Table name: sys_config
#
#  group :string(64)       not null
#  name  :string(128)      not null
#  value :string(255)
#

