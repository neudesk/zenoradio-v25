class GoAutoDial
  KEY_STRING = 'lR6BwcUPs0S51i7ZRiZC4b99XmLGeRbKfeCPCcr2'
  API_TIME_INTERVAL = 60
  include HTTParty
  base_uri 'https://207.97.161.114/api'
  #debug_output $stderr
  
  # create new campaign
  # params - name,call_time,wavfile,dial_method,listeners,did,num_channels,active,dnc_file
  def self.add_campaign(campaign_id,name,call_time,wavfile,dial_method,listeners,did,num_channels,active,dnc_file)
    post('/campaign/addcampaign', :body => {:signature => get_timestamp("addcampaign"),
        :campaign_id => campaign_id,
        :name => name,
        :call_time => call_time,
        :wavfile => wavfile,
        :dial_method => dial_method,
        :listeners => listeners,
        :did => did,
        :num_channels =>num_channels,
        :active => active,
        :dnc_file => dnc_file
      },:verify => false).parsed_response
  end
  
  # status - active, inactive
  def self.change_campaign_status(status,campaign_id)
    action = status.present? && status == true ? "setactive" : "setinactive"
    url = "/campaign/"+action
    post(url, :body => {:signature => get_timestamp(action),:campaign_id => campaign_id}, :verify => false).parsed_response
  end
  
  #return saved carrier's
  def self.get_carrier
    get('/carrier/index', :query => {:signature => get_timestamp('index')}, :verify => false).parsed_response
  end
  
  #return saved call times
  def self.get_call_time
    get('/calltime/index', :query => {:signature => get_timestamp('index')}, :verify => false).parsed_response
  end
  
  #set call time - 
  #params - call_time_id, call_time_name, ct_default_start, ct_default_stop
  def self.add_call_time(call_time_id, call_time_name, ct_default_start, ct_default_stop)
    post('/calltime/addcalltime', :body =>{:signature => get_timestamp('addcalltime'),
        :call_time_id => call_time_id.to_s,
        :call_time_name => call_time_name.to_s,
        :ct_default_start => ct_default_start.to_s,
        :ct_default_stop => ct_default_stop.to_s }, :verify => false).parsed_response
  end
  
  # return DNC List
  def self.get_dnc_list
    get('/campaign/dnclist', :query => {:signature => get_timestamp('dnclist')},:verify => false).parsed_response
  end
  
  # return all statuses
  def self.get_campaign_statuses
    get('/campaign/statuses', :query => {:signature => get_timestamp('statuses')},:verify => false).parsed_response
  end
  
  # return all campaigns from GoAutoDial
  def self.get_campaigns
    get('/campaign/campaigns', :query => {:signature => get_timestamp('campaigns')},:verify => false)
  end
  
  # return statuses for a specified campaign
  # params[:campaign_id]
  def self.get_campaign_status(campaign_id)
    get('/campaign/stats', :query => {:signature => get_timestamp('stats'), :campaign_id => campaign_id},:verify => false).parsed_response
  end
  
  # delete campaign
  # params[:campaign_id]
  def self.delete_campaign(campaign_id)
    post('/campaign/deletecampaign', :body => {:signature => get_timestamp('deletecampaign'),:campaign_id => campaign_id}, :verify => false).parsed_response
  end
  
  private 
  def self.get_timestamp(action)
    time = (get('/timestamp',:verify => false).parsed_response.to_i / API_TIME_INTERVAL).floor * API_TIME_INTERVAL
    key_str = KEY_STRING + '_' + action + '_' + time.to_s
    Digest::MD5.hexdigest(key_str)
  end
end