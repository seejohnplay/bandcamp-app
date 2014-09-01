require 'rails_helper'

describe PostsController do

  {new: :get, create: :post, destroy: :delete}.each do |action, method|
    it "must be logged in to access the #{action} action" do
      send(method, action, :id => FactoryGirl.create(:post_album))
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eql ('You need to sign in or sign up before continuing.')
    end
  end
end