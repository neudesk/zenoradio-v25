ZenoRadio::Application.routes.draw do
  get "api/station"
  get "api/all_stations"
  get "api/country"
  get "api/timestamp"
  get "api/countries"
  get "tracking_users/index"
  get "search/content_search"

  get "data_gateways/index"

  get "prompts/index"

  post 'application/slider_search' => 'application#slider_search'
  get 'my_radio/slider_search' => 'my_radio#slider_search'
  get 'settings/slider_search' => 'settings#slider_search'
  get 'prompts/slider_search' => 'prompts#slider_search'

  get 'download' => "download#download", as: "download"
  get "/banner1/:id" => "banner#version1", as: "banner1"
  get "/banner2/:id" => "banner#version2", as: "banner2"
  get "/banner3/:id" => "banner#version3", as: "banner3"
  get "/banner4/:id" => "banner#version4", as: "banner4"
  get "/banner5/:id" => "banner#version5", as: "banner5"
  get "/banner6/:id" => "banner#version6", as: "banner6"
  get "/banner7/:id" => "banner#version7", as: "banner7"

  get 'edit_account' => "users#edit_account", as: "edit_account"
  post 'update_account' => "users#update_account", as: "update_account"
  as :user do
    get "/logout" => "devise/sessions#destroy", as: "logout"
    get "/login" => "devise/sessions#new", as: "login"
  end
  devise_for :users, :controllers => {:sessions => 'sessions' }
  
  scope "/admin" do
    resources :users, :only => [:index, :show, :edit, :update, :new, :create] do
      member do
        put :toggle_lock
        get :info
        delete :destroy
        post :switch
      end
      collection do
        post  :index
        post :save
        match :users_account, :via => [:get, :post, :put]
        match :users_account1, :via => [:get, :post, :put]
        get :groups_options
        get :gateways_checklist
        get :group_list
        get :reset_password
        post :submit_reset_password
      end
    end
    resources :accounts, :only => [:create]
  end
  match 'my_account', :to => 'users#my_account', :via => [:get, :put]

  root :to => "home#index"

  get 'home/get_status' => 'home#get_status'
  get 'home/get_stations' => 'home#get_stations'
  get 'home/get_map_of_listeners' => 'home#get_map_of_listeners'
  
  get "maps/draw" => "maps#draw"
  put "track_customize" => "home#track_customize"
  get 'charts/countries' => 'charts#countries'
  get 'charts/:country_id/stations' => 'charts#stations'
  get 'charts/:gateway_id/channels' => 'charts#channels'
  get 'charts/aggregate' => "charts#aggregate"
  get 'load_data_for_select' => "charts#load_gateways_or_dids_for_select"
  get 'load_custom' => "charts#load_custom"

  get 'tracking/did' => "tracking#did"
  get 'tracking/stations' => "tracking#stations"
  get 'tracking/country' => "tracking#country"

  get "my_radio/station" => "my_radio#station"
  put "my_radio/station" => "my_radio#update_station"

  post "prompts" => "prompts#save"
  match "prompts/:id/gsm_audio.gsm" => "prompts#gsm_audio", :as => :prompts_gsm_audio, :via => :get
  match "prompts/:id/gsm_audio.mp3" => "prompts#mp3_audio", :as => :prompts_mp3_audio, :via => :get
  match "prompts/:id/wav_audio.wav" => "prompts#wav_audio", :as => :prompts_wav_audio, :via => :get
  match "prompts/:id/edit" => "prompts#edit", :as => :edit_prompt, :via => :get
  match "prompts/:id" => "prompts#update", :as => :prompt, :via => :put
  match "prompts/:id" => "prompts#destroy", :as => :prompt, :via => :delete

  # match "data_gateways/:data_gateway_id/prompts" => "data_gateways#prompts", :as => :data_gateway_prompts, :via => :get
  # match "data_gateways/:data_gateway_id/prompts" => "data_gateways#update_prompts", :as => :data_gateway_prompts, :via => :put

  get 'reachout_tab_settings/index' => 'reachout_tab_settings#index', :as => :reachout_tab_settings 
  get 'reachout_tab_settings/search_phone' => 'reachout_tab_settings#search_phone'
  post 'reachout_tab_settings/upload_dnc_file' => 'reachout_tab_settings#upload_dnc_file'
  post 'reachout_tab_settings/add_setting' => 'reachout_tab_settings#add_setting'
  post 'reachout_tab_settings/add_call_time' => 'reachout_tab_settings#add_call_time'
  post 'reachout_tab_settings/add_default_prompt' => 'reachout_tab_settings#add_default_prompt'
  post 'reachout_tab_settings/add_phone_dnc' => 'reachout_tab_settings#add_phone_dnc'
  put 'reachout_tab_settings/update_setting/:id' => 'reachout_tab_settings#update_setting', :as => :reachout_tab_settings_update 
  put 'reachout_tab_settings/activate_broadcaster' => 'reachout_tab_settings#activate_broadcaster'
  put 'reachout_tab_settings/activate_rca' => 'reachout_tab_settings#activate_rca'
  delete 'reachout_tab_settings/delete_phone_dnc/:id' => 'reachout_tab_settings#delete_phone_dnc'
  
  get 'campaign_results/index' => 'campaign_results#index'
  get 'campaign_results/get_campaigns_by_gateway_id' => 'campaign_results#get_campaigns_by_gateway_id'
  get 'campaign_results/get_campaign_status' => 'campaign_results#get_campaign_status'
  delete 'campaign_results/destroy_campaign' => 'campaign_results#destroy_campaign'

  
  
  
  

  delete 'reachout_tab/destroy_campaign' => 'reachout_tab#destroy_campaign'

  resources :mass_updates do
    collection do
      get :data_groups
      get :save_data_groups
      get :data_group_objects
      post :save_data_groups

      get :data_tags
      get :data_tag_objects
      get :save_data_tags
      post :save_data_tags
    end
  end

  resources :data_gateway_prompts
  
  resources :reachout_tab do
    collection do
      get :index
      post :save
    end
  end

  resources :new_settings do
    collection do
    end
    member do
    end
  end
  
  resources :stations
  resources :data_gateway_conferences do
    member do
      get :switch
    end
  end
  resources :pending_users do
    collection do
      get :all
      get :save
    end
    member do
      post :ignore
      post :duplicate
      post :approved
    end
  end

  resources :data_numerical_reports do
    collection do
      get :rca_minutes
      get :country_minutes 
    end
  end

  resources :users_and_tags, :only => "index" do
    collection do
      get :tagging
      get :data_group
      get :group_content
      get :tagging_content
      get :group_child_data
      get :group_detail
      put :assign_data
      put :assign_tagging
      get :tagging_child_data
    end
  end

  resources :graphs do
    collection do
      get :chart_a
      get :change_chart_c
      get :change_chart_d
      get :change_total_chart
    end
  end
  resources :reports do
    collection do
      get :get_graphs
    end
  end

  resources :extensions, :only => ["index", "destroy"] do
    collection do
      get :search_stream
      get :get_contents
      get :content

      match 'gateway_content/:gateway_content_id/edit' => 'extensions#edit_gateway_content', :as => :edit_gateway_content, :via => :get
      match 'gateway_content/:gateway_content_id/update' => 'extensions#update_gateway_content', :as => :update_gateway_content, :via => :put

      match 'gateway_contents/new' => 'extensions#add_existing_gateway_content', :as => :add_existing_gateway_content, :via => :get
      match 'gateway_contents/create' => 'extensions#save_existing_gateway_content', :as => :save_existing_gateway_content, :via => :post
    end
  end

  resources :data_gateways, :only => ["update", "new", "create", "edit", 'destroy'] do
    collection do
      post :request_content
    end
    member do
      put :update_station
      put :update_prompt
      post :manage_phones
      post :add_phone
      post :create_extension
    end
    get :assign_dids, controller: :settings
    put :update_station_dids, controller: :settings
    put :unassign_station_dids, controller: :settings
    get :dids_scroll, controller: :settings
  end

  put '/update', :to => 'setting#update_email'

  resources :system_variables, :only => ["index", "update"] do
    collection do
      put :update_email
    end
  end


  resources :settings, :only => ["index", "update"] do
  end
  
  resources :data_contents do
    collection do
      post :suggestion
    end
  end






end
