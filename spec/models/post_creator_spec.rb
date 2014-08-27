require 'rails_helper'

describe PostCreator do
  before do
    @album_post = Post.new(url: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s)
    @track_post = Post.new(url: (Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s)
    @no_playable_content = Post.new(url: (Rails.root + 'spec/support/track/no_playable_content/MicksplosionsBigGiantCircles.html').to_s)
  end

  describe '.create', 'album' do
    before do
      PostCreator.create(@album_post)
    end

    it 'should properly extract attributes from HTML Bandcamp album page' do
      expect(@album_post.url).to eql((Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s)
      expect(@album_post.embed_code).to eql(3664776922)
      expect(@album_post.link_type).to eql('album')
      expect(@album_post.title).to eql('He(a)d Zirkus')
      expect(@album_post.artist).to eql('Miss Walker')
      expect(@album_post.description[0..11]).to eql('<br />He(a)d')
      expect(@album_post.artist_url).to eql('')
      expect(@album_post.popularity).to eql(0)
    end

    it 'should create a valid album post' do
      expect(@album_post).to be_valid
    end
  end

  describe '.create', 'track' do
    before do
      PostCreator.create(@track_post)
    end

    it 'should properly extract attributes from HTML Bandcamp single track page' do
      expect(@track_post.url).to eql((Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s)
      expect(@track_post.embed_code).to eql(966522966)
      expect(@track_post.link_type).to eql('track')
      expect(@track_post.title).to eql('Re-do')
      expect(@track_post.artist).to eql('Modern Baseball')
      expect(@track_post.description[0..11]).to eql('<br />Re-do ')
      expect(@track_post.artist_url).to eql('http://modernbaseball.limitedrun.com')
      expect(@track_post.popularity).to eql(0)
    end

    it 'should create a valid track post' do
      expect(@track_post).to be_valid
    end
  end

  describe '.create', 'no playable content' do
    before do
      PostCreator.create(@no_playable_content)
    end

    it 'should not be valid' do
      expect(@no_playable_content).to_not be_valid
    end
  end
end