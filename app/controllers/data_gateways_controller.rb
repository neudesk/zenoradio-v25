class DataGatewaysController < ApplicationController
  respond_to :js, :html

  before_filter :authenticate_user!
  before_filter :get_stations, except: [:prompts, :update, :station, :new, :create, :edit, :destroy, :update_prompts]

  def index
  end

  def update_prompt
    flash[:hash] = "prompts"
    @station = DataGateway.find(params[:id])
    if @station.update_attributes(params[:data_gateway])
      redirect_to :back, notice: "You have successfully updated prompts."
    else
      redirect_to :back, alert: "Error Occured. Please contact System Administrator."
    end
  end

  def update_station
    flash[:hash] = "information"
    @station = DataGateway.find(params[:id])
    if @station.update_attributes(params[:data_gateway])
      flash[:notice] = "You have successfully updated #{@station.title} details."
      @next = request.env['HTTP_REFERER']
    end
  end

  def manage_phones
    if params[:selected_dids].present?
      params[:selected_dids].each do |did|
        entryway = DataEntryway.find_by_id(did.to_i)
        entryway.update_attributes(gateway_id: nil) if entryway.present?
      end
      redirect_to :back, notice: "Successfully deleted phone numbers."
    else
      redirect_to :back, notice: "There's no phone to be deleted."
    end
  end

  def add_phone
    if params[:data_gateway][:custom_entryways].to_i != 0
      @station = DataGateway.find_by_id(params[:id])
      @phone = DataEntryway.find_by_id(params[:data_gateway][:custom_entryways].to_i)
      if @phone.update_attributes(gateway_id: @station.id)
        redirect_to :back, notice: "You have successfully added new phone number."
      else
        redirect_to :back, alert: "Error Occured. Please try again."
      end
    else
      redirect_to :back, alert: "No phone number was inputted. Please try again."
    end
  end

  def create_extension
    @station = DataGateway.find_by_id(params[:id])
    extension_params = params[:data_content]
    return redirect_to :back, alert: "Media URL can't be blank." unless extension_params[:media_url].present?
    extension_params[:media_url] = extension_params[:media_url].gsub("[", "").gsub("]", "").gsub("\"", "")
    extension = extension_params.delete(:extension)
    return redirect_to :back, alert: "Channel Number can't be blank" unless extension.present?
    return redirect_to :back, alert: "Invalid Channel Number" if extension.to_i == 0
    if DataContent.where(id: extension_params[:media_url]).first.present?
      content = DataContent.where(id: extension_params[:media_url]).first
      @station.data_gateway_conferences.create(content_id: content.id, extension: extension)
      redirect_to :back, notice: "You have successfully linked stream to this station."
    else
      content = DataContent.create(extension_params)
      @station.data_gateway_conferences.create(content_id: content.id, extension: extension)
      redirect_to :back, notice: "You have created new extension."
    end
  end

  #==========================================================================
  # Method: get
  # Parameters:
  # + name:, format:
  # Responses:
  #  - prompts.js.haml
  # Description: Loading prompts tab for Settings page
  # Notes: 
  #==========================================================================
  def prompts
    @prompt = DataGatewayPrompt.new
    @station = DataGateway.find params[:data_gateway_id]
    @prompts = @station.data_gateway_prompts

    respond_to do |format|
      format.js
    end
  end

  def new
    @station = DataGateway.new
  end

  def create
    if marketer?
      @new_station = DataGateway.new(params[:data_gateway])
      if @new_station.save 
        flash[:notice] = "You have successfully created new station."
        @next = request.env['HTTP_REFERER']
      end
    else
      flash[:alert] = "You don't have the rights to perform necessary action."
      @next = root_url
    end
  end

    # if current_user.is_marketer?
    #   @station = DataGateway.new(params[:data_gateway])
    #   if @station.save
    #     free_entryway_ids = params[:'free_entryway_ids']
    #     thirdparty_ids = params[:'3rdparty_ids']

    #     entryway_ids_hash = {}
    #     free_entryway_ids.each_with_index do |entry_id, index|
    #       if !entryway_ids_hash[entry_id.to_i]
    #         entryway_ids_hash[entry_id.to_i] = thirdparty_ids[index].to_i
    #       end
    #     end

    #     entryways = DataEntryway.where(:id => entryway_ids_hash.keys)


    #     entryways.each do |entry|
    #       if entryway_ids_hash[entry.id] != 0
    #         entry.send("3rdparty_id=", entryway_ids_hash[entry.id])
    #       end
    #       entry.gateway_id = @station.id
    #       entry.save
    #     end


    #     redirect_to settings_path, notice: "Created successfully."
    #   else
    #     flash[:error] = "Please input the requied fields in (*)"
    #     flash[:error] =  "<ul>" + @station.errors.messages.values.map { |o| o.map{|p| "<li>"+p+"</li>"}.join(" ") }.join(" ") + "</ul>"
    #     render :action => 'new'
    #   end
    # end
  # end

  def edit
    @station = DataGateway.find(params[:id])
    @entryways = @station.data_entryways
  end
  
  def update
    gateway = DataGateway.find_by_id(params[:id])
     content_id =  params[:data_gateway].present? && params[:data_gateway]["data_gateway_conferences_attributes"].present? ? params[:data_gateway]["data_gateway_conferences_attributes"]["0"]["content_id"] : nil
     if content_id.present?
       data_content = DataContent.find(content_id)
       data_content.update_attribute(:is_deleted,false) if data_content.is_deleted == true
     end
    status = gateway.update_attributes(params[:data_gateway])

    if status
      redirect_to :back, notice: "Your gateway was successfully updated."
    else

      flash[:error] =  "<ul>" + gateway.errors.messages.values.map { |o| o.map{|p| "<li>"+p+"</li>"}.join(" ") }.join(" ") + "</ul>"
      flash[:error] = flash[:error] + "<ul><li>Your gateway was unsuccessfully updated.</li></ul>"
      redirect_to :back
    end

  end

  def destroy
    @gateway = DataGateway.find_by_id(params[:id])
    if @gateway.is_deleted
      redirect_to settings_path, notice: "Your gateway has been deleted."
    elsif @gateway.update_attributes(is_deleted: true)
      
      @gateway.create_activity key: 'data_gateway.destroy_gateway', owner: current_user, trackable_title: @gateway.title, parameters: {:gateway_id => @gateway.id}    
      redirect_to settings_path, notice: "Your gateway was successfully deleted."
    else
      flash[:error] =  "<ul>" + @gateway.errors.messages.values.map { |o| o.map{|p| "<li>"+p+"</li>"}.join(" ") }.join(" ") + "</ul>"
      flash[:error] = flash[:error] + "<ul><li>Your gateway was unsuccessfully deleted.</li></ul>"
      redirect_to settings_path
    end
  end

  def request_content
    email_config = SysConfig.get_config("UI_CONFIG",
      "EMAIL")
    if !email_config
      emails = User.joins(:sys_user_permission).where("sys_user_permission.is_super_user" => true).pluck(:email)
    else
      emails = [email_config.value]
    end
    UserMailer.request_content(params[:suggestion].merge!({to_emails: emails, from_email: current_user.email})).deliver
    redirect_to :back, notice: "Thanks for your request."
  end
end
