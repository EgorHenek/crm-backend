require "rails_helper"

RSpec.describe PromotesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/promotes").to route_to("promotes#index")
    end

    it "routes to #show" do
      expect(:get => "/promotes/1").to route_to("promotes#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/promotes").to route_to("promotes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/promotes/1").to route_to("promotes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/promotes/1").to route_to("promotes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/promotes/1").to route_to("promotes#destroy", :id => "1")
    end
  end
end
