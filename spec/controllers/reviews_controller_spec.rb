require 'rails_helper'

describe ReviewsController do
  let(:blog_post) { FactoryGirl.create(:post_album) }

  describe 'GET #index' do
    context 'when a review exists'
    it 'assigns @reviews' do
      review = Review.create(post_id: blog_post.id, body: 'First review!')
      xhr :get, :index, post_id: blog_post.id, format: :js
      expect(assigns(:reviews)).to eq([review])
    end

    it 'renders the index template' do
      xhr :get, :index, post_id: blog_post.id, format: :js
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    context 'when instantiating a new review for a post' do
      it 'instantiates a new review' do
        xhr :get, :new, post_id: blog_post.id, format: :js
        expect(assigns(:review)).to be_a_new(Review)
      end
      it 'renders the new template' do
        xhr :get, :new, post_id: blog_post.id, format: :js
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'when review is valid' do
      it 'renders the reviews index partial' do

        post :create, post_id: blog_post.id, review: {body: 'First review!'}, format: :js

        expect(response).to render_template(:index)
        expect(flash[:success]).to eq('Your review was successfully saved!')
      end
    end

    context 'when review body length is too short' do
      it 'renders the review new partial' do

        post :create, post_id: blog_post.id, review: {body: 'F'}, format: :js

        expect(response).to render_template(:new)
        expect(assigns(:review).errors[:body]).to include('is too short (minimum is 2 characters)')
      end
    end
  end
end