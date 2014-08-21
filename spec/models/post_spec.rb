require 'rails_helper'

describe Post do
  before do
    @album_post = Post.new(url: (Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s)
    @track_post = Post.new(url: (Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s)
  end

  describe 'setup album post' do
    before do
      @album_post.setup
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

    it 'should save a valid album post' do
      @album_post.save

      expect(@album_post).to be_valid
    end
  end

  describe 'setup track post' do
    before do
      @track_post.setup
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

    it 'should save a valid track post' do
      @track_post.save

      expect(@track_post).to be_valid
    end
  end


  describe 'embed code' do
    it 'should not allow two posts with the same embed code' do
      @album_post.setup
      @album_post.save
      another_album_post = Post.new(url: @album_post.url)
      another_album_post.setup
      another_album_post.save

      expect(another_album_post).to_not be_valid
    end
  end
end