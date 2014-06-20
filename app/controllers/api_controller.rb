class ApiController < ApplicationController
  before_filter :valid_request, except: :timestamp

  KEY_STRING = 'fbVFTjcTlLsbZg8th7O1iyOrkEjLnHSYg98KN554'
  WIDGET_DID = 1700
  
  CODE_OK = 0
  CODE_INVALID_KEY = -1
  CODE_INVALID_PARAM = 1
  
  def timestamp
    render :json => { :timestamp => Time.now.to_i }
  end
  
  def station
    query = params[:query]
    stations_response = []
    if !query.blank? && query.length > 1
      abs_url = "#{request.protocol}#{request.host_with_port}"
      where_widget_did = "did_e164 LIKE '#{WIDGET_DID}%'"
      stations = DataGateway
      .select('data_gateway.*, count(data_content.id) as n_data_content,
                        data_group_language.title as language_title, data_group_genre.title as genre_title,
                        data_content.language_id as data_content_language, data_content.genre_id as data_content_genre')
      .joins(data_gateway_conferences: :data_content)
      .joins('LEFT JOIN `data_group_language` ON `data_group_language`.`id` = `data_content`.`language_id`')
      .joins('LEFT JOIN `data_group_genre` ON `data_group_genre`.`id` = `data_content`.`genre_id`')
      .where("data_gateway.title like ? AND flag_broadcaster=1", "%#{query}%")
      .group('data_gateway.id')
      .having('n_data_content = 1')
      
      stations_response = stations.map { |c| {:name => c.title,
          :country => ( c.country_id.nil? ? '' : c.data_group_country.title ),
          :country_code => ( c.country_id.nil? ? '' : c.data_group_country.iso_alpha_2),
          :website => c.website,
          :logo => (c.logo.exists? ? abs_url + c.logo(:large) : ''),       
          :main_did => ( c.main_did.nil? ?  '0' : c.main_did.did_e164 ),
          :genre => (c.genre_title.nil? ? '' : c.genre_title),
          :language => (c.language_title.nil? ? '' :  c.language_title),
          :widget_did => (c.data_entryways.where(where_widget_did).first.nil? ? '' : c.data_entryways.where(where_widget_did).first.did_e164)
        } }  
    else
      @code = CODE_INVALID_PARAM
    end
    response = { :code => @code, :stations => stations_response }
    render :json => response   
  end
  
  def all_stations
    stations_response = []
    stations = DataGateway
    .select("data_gateway.title, data_gateway.country_id,data_gateway.id as dg_id, count(data_content.id) as n_data_content,
              data_entryway.did_e164 as did_e164,data_group_country.title as country_title, data_group_country.iso_alpha_2 as iso_alpha_2,
               data_group_language.title as language_title, data_group_genre.title as genre_title,
               (Select did_e164 from data_entryway where did_e164 LIKE '#{WIDGET_DID}%' and gateway_id = dg_id limit 1) as widget_did")
    .joins(data_gateway_conferences: :data_content)
    .joins('LEFT JOIN `data_entryway` ON `data_entryway`.`gateway_id` = `data_gateway`.`id` and `data_entryway`.`id` = data_gateway.data_entryway_id')
    .joins(:data_group_country)
    .joins('LEFT JOIN `data_group_language` ON `data_group_language`.`id` = `data_content`.`language_id`')
    .joins('LEFT JOIN `data_group_genre` ON `data_group_genre`.`id` = `data_content`.`genre_id`')
    .where("flag_broadcaster=1")
    .group('data_gateway.id')
    .having('n_data_content = 1')

      
    stations_response = stations.map { |c| {:name => c.title,
        :country => ( c.country_id.nil? ? '' : c.country_title ),
        :country_code => ( c.country_id.nil? ? '' : c.iso_alpha_2),
        :main_did => ( c.did_e164.nil? ?  '0' : c.did_e164 ),
        :genre => (c.genre_title.nil? ? '' : c.genre_title),
        :language => (c.language_title.nil? ? '' :  c.language_title),
        :widget_did => (c.widget_did.nil? ? '0' : c.widget_did)
      } }  

    response = { :code => @code, :stations => stations_response }
    render :json => response   
  end
  
  
  
  def country
    query = params[:query]
    countries_response = []
    if !query.blank? && query.length > 1
      where_widget_did = "did_e164 LIKE '#{WIDGET_DID}%'"
      if query.length == 2
        where_country = "iso_alpha_2 like ?"
      else
        where_country = "title like ?"         
      end
      countries = DataGroupCountry.where("#{where_country} AND is_deleted=0", "%#{query}%").order("trim(title)")
      countries.each do |country|        
        stations = DataGateway
        .select('data_gateway.*, count(data_content.id) as n_data_content,
                        data_group_language.title as language_title, data_group_genre.title as genre_title,
                        data_content.language_id as data_content_language, data_content.genre_id as data_content_genre')
        .joins(data_gateway_conferences: :data_content)
        .joins('LEFT JOIN `data_group_language` ON `data_group_language`.`id` = `data_content`.`language_id`')
        .joins('LEFT JOIN `data_group_genre` ON `data_group_genre`.`id` = `data_content`.`genre_id`')
        .where("data_gateway.country_id = ? AND flag_broadcaster=1", country.id)
        .group('data_gateway.id')
        .having('n_data_content = 1')
        stations_response = stations.map { |c| {:name => c.title,               
            :main_did => ( c.main_did.nil? ?  '0' : c.main_did.did_e164 ),
            :genre => (c.genre_title.nil? ? '' : c.genre_title),
            :language => (c.language_title.nil? ? '' :  c.language_title),
            :widget_did => (c.data_entryways.where(where_widget_did).first.nil? ? '' : c.data_entryways.where(where_widget_did).first.did_e164)
          } }
        country_response = { :name => country.title, :country_code => country.iso_alpha_2, :stations => stations_response }
        countries_response.push(country_response)
      end
    else
      @code = CODE_INVALID_PARAM
    end
    response = { :code => @code, :countries => countries_response }
    render :json => response
  end
  
  def countries
    countries_response = []
    
    countries = DataGroupCountry
    .select('DISTINCT data_group_country.*, count(data_content.id) as n_data_content')
    .joins(data_gateways: [{data_gateway_conferences: :data_content}])
    .where('data_group_country.is_deleted=0 AND data_group_country.title IS NOT NULL AND data_gateway.is_deleted=0 AND data_content.is_deleted = 0 AND data_gateway.flag_broadcaster=1')
    .group('data_gateway.id')
    .having('n_data_content = 1')
    .order("trim(data_group_country.title)")

    countries_response = countries.map { |c| {:name => c.title, :country_code => c.iso_alpha_2}}
    response = { :code => @code, :countries => countries_response }
    render :json => response
  end
  

  private
  def valid_request
    key_params = params[:key]
    timestamp = ((Time.now.to_i)/60).floor * 60
    key_str = KEY_STRING + '_' + params[:action] + '_' + timestamp.to_s
    key_md5 = Digest::MD5.hexdigest(key_str)
    #      p key_md5
    @code = CODE_OK
    #      unless key_md5 == key_params
    #        @code = CODE_INVALID_KEY
    #        render :json => { :code => @code }
    #      end
  end
  
end