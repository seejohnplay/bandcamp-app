require 'rails_helper'

describe CommentsController do
  let(:blog_post) { FactoryGirl.create(:post) }

  describe 'GET #index' do
    context 'when a comment exists'
    it 'assigns @comments' do
      comment = Comment.create(post_id: blog_post.id, body: 'First comment!')
      xhr :get, :index, post_id: blog_post.id, format: :js
      expect(assigns(:comments)).to eq([comment])
    end

    it 'renders the index template' do
      xhr :get, :index, post_id: blog_post.id, format: :js
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    context 'when instantiating a new comment for a post' do
      it 'instantiates a new comment' do
        xhr :get, :new, post_id: blog_post.id, format: :js
        expect(assigns(:comment)).to be_a_new(Comment)
      end
      it 'renders the new template' do
        xhr :get, :new, post_id: blog_post.id, format: :js
        expect(response).to render_template(:new)
      end
    end
  end

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