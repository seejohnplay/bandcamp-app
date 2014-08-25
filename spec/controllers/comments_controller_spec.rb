require 'rails_helper'

describe CommentsController do
  let(:blog_post) { FactoryGirl.create(:post) }

  describe 'POST #create' do
    context 'when comment is valid' do
      it 'renders the comments index partial' do

        post :create, post_id: blog_post.id, comment: {body: 'First comment!'}, format: :js

        expect(response).to render_template(:index)
        expect(flash[:success]).to eq('Your comment was successfully added!')
      end
    end

    context 'when comment body length is too short' do
      it 'renders the comments new partial' do

        post :create, post_id: blog_post.id, comment: {body: 'F'}, format: :js

        expect(response).to render_template(:new)
        expect(assigns(:comment).errors[:body]).to include('is too short (minimum is 2 characters)')
      end
    end
  end
end