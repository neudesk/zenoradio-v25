class SystemVariablesController < ApplicationController

  def index
    @email_config_form = EmailConfigForm.new

    @email_config = SysConfig.get_config("UI_CONFIG",
        "EMAIL")

    if @email_config
      @email = @email_config.value
    end

  end

  def update_email
    @email_config_form = EmailConfigForm.new(params[:email_config_form])
    if @email_config_form.valid?
      SysConfig.add_config(
        "UI_CONFIG",
        "EMAIL",
        @email_config_form.email)

      flash[:notice] = "Saved successfully"
    else
      flash[:error] = "Invalid inputed email"
    end
    
    redirect_to system_variables_path
  end

  
end
