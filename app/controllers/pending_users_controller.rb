class PendingUsersController < ApplicationController
  before_filter :authenticate_user!, except: [:new, :create]
  def index
    @users = PendingUser.where(status: Status::UNPROCESSED).order("id DESC")
    @q = @users.search(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(15)
    @user = PendingUser.new
  end

  def new
    @user = PendingUser.new
  end

  def create
    @user = PendingUser.new(params[:pending_user])
    @user.signup_date = Date.today
    if @user.save
      redirect_to "https://secure.echosign.com/public/hostedForm?formid=8WD64S34275D28"
    else
      render :new
    end
  end

  def save
  end

  def all
    @users = PendingUser.where("status != ?", Status::UNPROCESSED)
    @q = @users.search(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(15)
    @user = PendingUser.new

  end

  def ignore
    @user = PendingUser.find_by_id(params[:id])
    if @user.update_attributes(status: Status::IGNORED, note: params[:pending_user][:note])
      redirect_to :back, notice: "Successfully ignored pending user."
    else
      redirect_to :back, alert: "Error Occured. Please contact system Administrator"
    end
  end

  def duplicate
    @user = PendingUser.find_by_id(params[:id])
    if @user.update_attributes(status: Status::DUPLICATE, note: params[:pending_user][:note])
      redirect_to :back, notice: "Successfully mark user as duplicate."
    else
      redirect_to :back, alert: "Error Occured. Please contact system Administrator"
    end
  end

  def approved
    @user = PendingUser.find_by_id(params[:id])
    @bool, @new_user = PendingUser.create_from(params[:pending_user])
    if @bool
      @user.update_attributes(status: Status::PROCESSED, date_processed: Time.now)
      redirect_to user_path(@new_user, new_user: true), notice: "Successfully created new user."
    else
      @new_user.errors.messages.each do |key, val|
        key == :title ? @user.errors.add(:name, val.first) : @user.errors.add(key, val.first)
      end
      @user.permission_id = params[:pending_user][:permission_id]
      @user.new_group = params[:pending_user][:new_group]
      @user.group = params[:pending_user][:group]
      if @user.new_group.empty? && @user.group.empty?
        @user.errors.add(:group, "can't be blank")
      end
      render :show
    end

  end

  def show
    @user = PendingUser.find_by_id(params[:id])
  end
end
