class ReachoutTabListenerMinutesByGateway < ActiveRecord::Base
  attr_accessible :created_at, :listener_id, :gateway_id, :ani_e164, :did_e164, :minutes
end
