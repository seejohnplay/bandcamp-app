require 'rails_helper'

describe Post do
  let!(:post_track) { FactoryGirl.create(:post_track) }

  describe '#calculate_popularity' do
    it 'should return correct popularity number' do
      post_track.votes.create(direction: 'up')
      post_track.votes.create(direction: 'down')
      post_track.votes.create(direction: 'up')

      expect(post_track.calculate_popularity).to eql(1)
    end
  end

  describe 'embed code' do
    it 'should not allow two posts with the same embed code' do
      another_post = Post.new(url: post_track.url)
      PostCreator.create(another_post)

      expect(another_post).to_not be_valid
    end
  end
end