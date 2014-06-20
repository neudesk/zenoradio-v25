class PendingUser < ActiveRecord::Base
  self.table_name = :pending_users
  attr_accessible :address, :city, :company_name, :country, :email, :facebook, :genre, :language, :name, :phone, :state, :station_name, :streaming_url, :twitter, :website, :signup_date, :status, :note, :date_processed, :rca, :affiliate, :enabled, :on_air_schedule
  attr_accessor :filter, :permission_id, :group, :new_group

  validates :station_name, :streaming_url, :email, :name, :website, :country, :on_air_schedule, presence: true, on: :create
  validate :uniq_email, on: :create

  def uniq_email
    user = User.find_by_email(email)
    if user.present?
      self.errors.add(:email, "Already taken")
    end
  end


  def unprocessed?
    status == Status::UNPROCESSED
  end

  def duplicate?
    status == Status::DUPLICATE
  end

  def ignored?
    status == Status::IGNORED
  end

  def processed?
    status == Status::PROCESSED
  end

  def self.create_from(params)
    user = User.new
    user.permission_id = params[:permission_id]
    user.title = params[:name]
    user.email = params[:email]
    user.password = 
    user.facebook = params[:facebook]
    user.twitter = params[:twitter]
    user.address = params[:address]
    user.city = params[:city]
    user.state = params[:state]
    user.landline = params[:phone]
    password = user.default_password
    user.password = password
    user.rca = params[:rca]
    user.station_name = params[:station_name]
    user.streaming_url = params[:streaming_url]
    user.website = params[:website]
    user.language = params[:language]
    user.genre = params[:genre]
    user.affiliate = params[:affiliate]
    user.name = params[:company_name]
    user.enabled = params[:enabled]
    user.on_air_schedule = params[:on_air_schedule]
    unless user.permission_id == 1  
      if params[:new_group].empty? && params[:group].empty?
        user.errors.add(:group, "can't be blank")
        return user.valid? , user, user.errors
      end
    end
    if user.save
      user.save_countries([params[:country]]) if params[:country].present?
      user.new_group = params[:new_group]
      user.group = params[:group]
      if user.new_group.present?
        user.create_new_group(user.new_group)
      else
        user.save_relationships(user.group)
      end
    end
    return user.valid? , user
  end

  def self.random_password(length)
    o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    string = (0...length).map { o[rand(o.length)] }.join
  end
end
