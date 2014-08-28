require 'rails_helper'

describe Search do
  let!(:post_album) { FactoryGirl.create(:post_album) }
  let!(:post_track) { FactoryGirl.create(:post_track) }

  describe '.posts' do
    it 'should return posts with artist name that contains search term' do
      post_results = Search.new(post_album.artist)

      expect(post_results.posts.first.artist).to eql(post_album.artist)
    end

    it 'should return posts with title that contains search term' do
      post_results = Search.new(post_track.title)

      expect(post_results.posts.first.title).to eql(post_track.title)
    end

    it 'should return an empty array when search term has no matching results' do
      post_results = Search.new('not_a_matching_search_term')

      expect(post_results.posts).to eql([])
    end
  end
end