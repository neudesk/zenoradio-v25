require 'spec_helper'

describe "Maps" do
  describe "GET /maps/draw" do
    before do
      listener1 = build(:listener, :area_code => 205)
      listener1.save(:validate => false)
      listener2 = build(:listener, :area_code => 907)
      listener2.save(:validate => false)
      get maps_draw_path
    end
    subject { response }
    its(:status) { should be(200) }
    it "assigns @json" do
      listeners = Listener.all
      json = listeners.to_gmaps4rails do |lis, marker|
        count_lis = listeners.map(&:region).count(lis.region)
        marker.infowindow "#{lis.state_name lis.region}\n(#{count_lis} listener)\n"
      end
      assigns(:json).should eq(json)
    end
    it "render template maps/common" do
      expect(response).to render_template("maps/common")
    end
  end
end
