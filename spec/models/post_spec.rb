require 'rails_helper'

describe Post do
  let!(:post_track) { FactoryGirl.create(:post_track) }
  let(:user) { FactoryGirl.create(:user) }
  describe '#average_rating' do
    it 'should return a float value' do
      expect(post_track.average_rating).to be_a(Float)
    end

    it 'should equal zero when there are no ratings' do
      expect(post_track.average_rating).to eql(0.0)
    end

    it 'should return correct rating value' do
      Rating.create(post_id: post_track.id, user_id: user.id, score: 5)
      Rating.create(post_id: post_track.id, user_id: user.id, score: 2)

      expect(post_track.average_rating).to eql(3.5)
    end

    it 'should not include ratings of zero in calculations' do
      Rating.create(post_id: post_track.id, user_id: user.id, score: 5)
      Rating.create(post_id: post_track.id, user_id: user.id, score: 0)

      expect(post_track.average_rating).to eql(5.0)
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