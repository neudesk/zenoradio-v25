class UsersAndTagsController < ApplicationController
  # CALLBACKS
  before_filter :authenticate_user!

  # CONSTANTS
  RCA_NAME = "RCA"
  FIRST_VALUE = 1
  RD_NAME = "Third Party"
  SECOND_VALUE = 2
  BROADC_NAME = "Broadcaster"
  THIRD_VALUE = 3
  COUNTRY = "Country"
  LANGUAGE = "Language"
  GENRE = "Genre"

  USER_GROUP_IDS = {
    "RCA" => 1,
    "Third Party" => 2,
    "Broadcaster" => 3
  }

  TAGGINGS = {
    "Country" => 1,
    "Language" => 2,
    "Genre" => 3
  }

  ID_FIELDS = {
    1 => "rca_id",
    2 => "broadcast_id",
    3 => "3rdparty_id"
  }

  GROUP_MODELS = {
    1 => DataGroupRca,
    2 => DataGroup3rdparty,
    3 => DataGroupBroadcast
  }

  def index
    get_data_for_group
  end

  def tagging
    @tagging_data = DataGroupCountry.active_list.order(:title)
    @data_taggings = Array(TAGGINGS)
    render :partial => "tagging", locals: {tagging_data: @tagging_data,
                                           data_taggings: @data_taggings}
  end

  def data_group
    get_data_for_group
    render :partial => "data_groups", locals: {data_group_list: @data_group_list,
                                               countries: @countries,
                                               us_id: @us_id,
                                               group_data: @group_data}
  end

  def group_content
    countries = DataGroupCountry.joins(:data_gateways).group(:id).order(:title)
    get_group_data
    us_id = countries.map{|c| c.id if c.title == 'United States of America'}
    render :partial => "group_data", locals: {countries: countries, us_id: us_id}
  end

  def group_detail
    get_group_data
    render :partial => "data_detail"
  end

  def tagging_content
    if params[:tagging].to_i == FIRST_VALUE
      @tagging_data = DataGroupCountry.active_list.order(:title)
    elsif params[:tagging].to_i == SECOND_VALUE
      @tagging_data = DataGroupLanguage.active_list
    else
      @tagging_data = DataGroupGenre.active_list
    end
    render :partial => "tagging_data", locals: {tagging_data: @tagging_data}
  end

  def group_child_data
    group_id = params[:group].to_i
    country_id = params[:country].to_i
    id_field = group_id == FIRST_VALUE ? "rca_id" : "broadcast_id"
    if group_id == SECOND_VALUE
      data = DataEntryway.active_list.where(country_id: country_id).map{|x| {id: x.id, title: x.title, group_id: x.send("3rdparty_id").to_i}}
    else
      data = DataGateway.active_list.where(country_id: country_id).map{|x| {id: x.id, title: x.title, group_id: x.send(ID_FIELDS[group_id]).to_i}}
    end
    render :partial => "group_child", locals: {data: data, group: params[:group_id].to_i}
  end

  def assign_data 
    group = params[:group].to_i
    group_id = params[:group_id].to_i
    ids = params[:ids].split("__")
    un_ids = params[:un_ids].split("__")
    if group == FIRST_VALUE 
      DataGateway.where("id IN (?)", ids).update_all("rca_id = #{group_id}")
      DataGateway.where("id IN (?) AND rca_id = ?", un_ids, group_id).update_all("rca_id = NULL")
    elsif group == SECOND_VALUE
      DataEntryway.where("id IN (?)", ids).update_all("3rdparty_id = #{group_id}")
      DataEntryway.where("id IN (?) AND 3rdparty_id = ?", un_ids, group_id).update_all("3rdparty_id = NULL")
    else
      DataGateway.where("id IN (?)", ids).update_all("broadcast_id = #{group_id}")
      DataGateway.where("id IN (?) AND broadcast_id = ?", un_ids, group_id).update_all("broadcast_id = NULL")
    end
    render :nothing => true   
  end

  def assign_tagging
    group = params[:group].to_i
    group_id = params[:group_id].to_i
    ids = params[:ids].split("__")
    un_ids = params[:un_ids].split("__")
    if group == FIRST_VALUE
      DataGateway.where("id IN (?)", ids).update_all("country_id = #{group_id}")
      DataGateway.where("id IN (?) AND country_id = ?", un_ids, group_id).update_all("country_id = NULL")
    elsif group == SECOND_VALUE
      DataContent.where("id IN (?)", ids).update_all("language_id = #{group_id}")
      DataContent.where("id IN (?) AND language_id = ?", un_ids, group_id).update_all("language_id = NULL")
    else
      DataContent.where("id IN (?)", ids).update_all("genre_id = #{group_id}")
      DataContent.where("id IN (?) AND genre_id = ?", un_ids, group_id).update_all("genre_id = NULL")
    end
    render :nothing => true
  end

  def tagging_child_data
    group = params[:group].to_i
    if group == FIRST_VALUE
      @data = DataGateway.active_list.map{|x| {id: x.id, title: x.title, group_id: x.country_id.to_i}}
    elsif group == SECOND_VALUE
      @data = DataContent.active_list.map{|x| {id: x.id, title: x.title, group_id: x.language_id.to_i}}
    else
      @data = DataContent.active_list.map{|x| {id: x.id, title: x.title, group_id: x.genre_id.to_i}}
    end
    @group = params[:group_id].to_i
    render :partial => "group_child", locals: {data: @data, group: @group}
  end

  protected

  def get_data_for_group
    @data_group_list = Array(USER_GROUP_IDS)
    @group_data = DataGroupRca.active_list.order("trim(title)").map{|r| [r.id, r.title]}
    @countries = DataGroupCountry.joins(:data_gateways).group(:id).order(:title)
    @us_id = @countries.map{|c| c.id if c.title == 'United States of America'}
  end

  def get_group_data
    model = GROUP_MODELS[params[:group].to_i]
    @group_data = model.active_list.order("trim(title)").map{|r| [r.id, r.title]}
  end

end

