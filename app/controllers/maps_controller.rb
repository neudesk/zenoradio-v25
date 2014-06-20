class MapsController < ApplicationController
  def draw
    count_lis = {}
    listeners = current_user.listeners
    @json = listeners.to_gmaps4rails do |lis, marker|
      count_lis = listeners.map(&:region).count(lis.region)
      marker.infowindow render_to_string(:partial => "maps/title_box", :locals => { :object => lis, count_lis: count_lis})
    end
    render_map(@json)
  end 

  protected
    def render_map(json)
      @json = json
      p json
      if @json.eql?("[]")
        render :text => "<div style = 'font-style:italic;font-size:18px;margin: 20px 0px;text-align:center'> No data available to US map!</div>".html_safe
      else
        render :template => 'maps/common', :layout => "map"
      end 
    end
end
