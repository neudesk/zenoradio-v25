class UsersController < ApplicationController
  skip_authorize_resource :only => [:my_account, :edit_account, :update_account]
  before_filter :authenticate_user!, :only => [:my_account, :edit_account, :update_account]
  PER_PAGE = 10

  # GET /users
  # GET /users.json
  def index
    @users = User.order("id").page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def new
    @user = User.new
  end

  def reset_password
    @user = current_user
  end

  def submit_reset_password
    @user = current_user
    if @user.valid_password?(params[:user][:old_password])
      if params[:user][:password] == params[:user][:password_confirmation]
        if params[:user][:old_password] == params[:user][:password]
          @user.errors.add(:password, "You should change the password")
        elsif @user.update_attributes(password: params[:user][:password])
          sign_in(@user, :bypass => true)
          return redirect_to root_url, notice: "Thank your for resetting your password."
        end
      else
        @user.errors.add(:password, "Password didn't match")
      end
    else
      @user.errors.add(:old_password, "Incorrect old password")      
    end
    render :reset_password
  end

  def save
    user_params = params[:user].dup
    group = user_params.delete("group")
    @new_group = user_params.delete("new_group")
    @tags = user_params.delete("tags_holder")
    @countries = user_params.delete("country_holder")
    @user = User.new(user_params)
    @user.password = @user.default_password
    if @user.save
      if @new_group.present?
        @user.create_new_group(@new_group)
      else
        @user.save_relationships(group)
      end
      @user.save_tags(@tags)
      @user.save_countries(@countries)
      redirect_to users_account_users_path(new_user: @user.id), notice: "Successfully create new user."
    else
      render "new"
    end
  end

  def switch
    @user = User.find_by_id(params[:id])
    sign_in(:user, @user)
    redirect_to root_path, notice: "You're now logged in as #{@user.title}."
  end

  def edit_account
    @tags = @current_user.tags_holder || @current_user.tags.collect { |x| x.title}.join(",")
    @countries = @current_user.country_holder || @current_user.countries.collect { |x| x.title}
  end

  def edit
    @user = User.find_by_id(params[:id])
    @tags = @user.tags_holder || @user.tags.collect { |x| x.title}.join(",")
    @countries = @user.country_holder || @user.countries.collect { |x| x.title}
  end

  def update
    @user = User.find_by_id(params[:id])
    user_params = params[:user].dup
    group = user_params.delete(:group)
    @tags = user_params.delete("tags_holder")
    @countries = user_params.delete("country_holder")
    @new_group = user_params.delete("new_group")
    if user_params[:password].blank? || user_params[:password_confirmation].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
    if @user.update_attributes(user_params)
      if @new_group.present?
        @user.create_new_group(@new_group)
      else
        @user.save_relationships(group)
      end
      @user.save_tags(@tags)
      @user.save_countries(@countries)
      if @user == current_user && user_params[:password].present?
        sign_in(@user, :bypass => true)
      end
      redirect_to users_account_users_path, notice: "You have successfully update #{@user.title} details."
    else
      render :edit
    end
  end

  def update_account
    user_params = params[:user].dup
    @tags = user_params.delete("tags_holder")
    @countries = user_params.delete("country_holder")
    @new_group = user_params.delete("new_group")
    group = user_params.delete("group")
    if params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
    if @current_user.update_attributes(user_params)
      @current_user.save_tags(@tags)
      @current_user.save_countries(@countries)
      redirect_to my_account_path, notice: "You have successfully update your account."
    else
      render "edit_account"
    end
  end

  def toggle_lock
    @user = User.find(params[:id])

    if @user.access_locked?
      @user.unlock_access!
    else
      @user.lock_access!
    end

    redirect_to users_path
  end

  def my_account
    @user = current_user
  end

  def info
    user = User.find_by_id(params[:id].to_i)
    user_info = user.extract_info
    user_info[:link] = user_path(user)
    render :json => user_info
  end

  def users_account
    if params[:filter].present?
      filter = params[:filter]
    else
      filter = params[:user].present? ? params[:user][:filter] : "0"
    end
    if filter == "0"
      @users = User.where(true)
    else
      @users = User.where(permission_id: filter)
    end
    @q = @users.search(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(PER_PAGE)
    @user = User.new
  end

  def users_account1
    if request.get?
      @user = User.new
      @user.data_group_rcas.build
      @user.data_group_3rdparties.build
      @user.data_group_broadcasts.build
      role ||= params[:search][:role] if params[:search]
      key ||= params[:search][:keyword] if params[:search]
      @users = User.filtered_list(role, key).order(:title).page(params[:page]).per(PER_PAGE)
    elsif request.post?
      @user = User.new
      role = params[:user][:role]
      if @user.save_with_assignments(params[:user], (params[:assignments].values rescue nil))
        flash[:success] = 'Successful create!'
        redirect_to :action => :users_account
      else
        @user.data_group_rcas.build
        @user.data_group_3rdparties.build
        @user.data_group_broadcasts.build
        @user.role = role
        @users = User.filtered_list(role, key).order(:title).page(params[:page]).per(PER_PAGE)
      end
    elsif request.put?
      @user = User.find_by_id(params[:id])
      params[:user].delete(:password) if params[:user][:password].blank?
      if @user.save_with_assignments(params[:user], (params[:assignments].values rescue nil))
        render :json => {}
      else
        render :json => {:errors => @user.errors.messages}
      end
    end
  end
  
  def destroy
    @user = User.find_by_id(params[:id])
    if @user.destroy
      redirect_to users_account_users_path, notice: "User was successfully deleted."
    else
      flash[:error] =  "<ul>" + @user.errors.messages.values.map { |o| o.map{|p| "<li>"+p+"</li>"}.join(" ") }.join(" ") + "</ul>"
      flash[:error] = flash[:error] + "<ul><li>User was unsuccessfully deleted.</li></ul>"
      redirect_to users_account_users_path
    end
  end

  def groups_options
    if request.xhr?
      role = params[:role].to_i
      data = case role
      when 2
        DataGroup3rdparty.all
      when 3
        DataGroupBroadcast.all
      when 4
        DataGroupRca.all
      end
    end 

    if params[:user_id].nil?
      render :json => {list: self.class.helpers.groups_for_select(data, params[:user_id]), selected: ""}
    else
      user = User.find_by_id(params[:user_id])
      case user.role_name
      when "Broadcast user"
        selected = user.sys_user_resource_broadcasts.first.broadcast_id
        name = selected.present? ? DataGroupBroadcast.find_by_id(selected).title : ""
      when "3rd party user"
        selected = user.sys_user_resource_3rdparties.first['3rdparty_id'] rescue nil
        name = selected.present? ? DataGroup3rdparty.find_by_id(selected).title : ""
      when "RCA user"
        selected = user.sys_user_resource_rcas.first.rca_id
        name = selected.present? ? DataGroupRca.find_by_id(selected).title : ""
      end
      render :json => {list: self.class.helpers.groups_for_select(data, selected), name: name}
    end
  end

  def gateways_checklist
    if request.xhr?
      role = params[:role].to_i
      if role == MyRadioHelper::Role::VALUES['rca'] or role == MyRadioHelper::Role::VALUES['broadcaster']
        data = DataGateway.with_country(params[:country].to_i)
                .list_with_status_on_group(role, params[:group].to_i)
      elsif role == MyRadioHelper::Role::VALUES['3rd_party']
        data = DataEntryway.with_country(params[:country].to_i)
                .list_with_status_on_group(params[:group].to_i)
      end
      # render :text => self.class.helpers.assignments_for_checklist(data)
      render :text => data.to_json
    end
  end

end
