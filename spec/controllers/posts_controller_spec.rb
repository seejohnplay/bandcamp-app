require 'rails_helper'

describe PostsController do
  let(:user) { FactoryGirl.create(:user) }

  {new: :get, create: :post, destroy: :delete}.each do |action, method|
    it "must be logged in to access the #{action} action" do
      send(method, action, :id => FactoryGirl.create(:post_album))
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eql ('You need to sign in or sign up before continuing.')
    end
  end

  describe 'DELETE #destroy' do
    before do
      sign_in(user)
    end

    context 'when user is admin' do
      it 'deletes post' do
        user.admin!
        post_album = FactoryGirl.create(:post_album)
        delete :destroy, id: post_album.id

        expect(response).to redirect_to(posts_path)
        expect(flash[:notice]).to eq('Post was destroyed.')
      end
    end

    context 'when user is not admin' do
      it 'does not delete post' do
        user.contributor!
        post_album = FactoryGirl.create(:post_album)
        delete :destroy, id: post_album.id

        expect(response).to redirect_to(posts_path)
        expect(flash[:notice]).to eq('You are not authorized to perform that action')
      end
    end
  end
end