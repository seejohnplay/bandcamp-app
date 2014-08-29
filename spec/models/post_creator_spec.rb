require 'rails_helper'

describe PostCreator do
  let(:post_album) { FactoryGirl.build(:post_album) }
  let(:post_track) { FactoryGirl.build(:post_track) }

  describe '.create', 'album' do
    before do
      PostCreator.create(post_album)
    end

    it 'should properly extract attributes from HTML Bandcamp album page' do
      expect(post_album.url).to eql((Rails.root + 'spec/support/album/HeadZirkusMissWalker.html').to_s)
      expect(post_album.embed_code).to eql(3664776922)
      expect(post_album.link_type).to eql('album')
      expect(post_album.title).to eql('He(a)d Zirkus')
      expect(post_album.artist).to eql('Miss Walker')
      expect(post_album.description[0..11]).to eql('<br />He(a)d')
      expect(post_album.artist_url).to eql('')
      expect(post_album.popularity).to eql(0)
    end

    it 'should create a valid album post' do
      expect(post_album).to be_valid
    end
  end

  describe '.create', 'track' do
    before do
      PostCreator.create(post_track)
    end

    it 'should properly extract attributes from HTML Bandcamp single track page' do
      expect(post_track.url).to eql((Rails.root + 'spec/support/track/RedoModernBaseball.html').to_s)
      expect(post_track.embed_code).to eql(966522966)
      expect(post_track.link_type).to eql('track')
      expect(post_track.title).to eql('Re-do')
      expect(post_track.artist).to eql('Modern Baseball')
      expect(post_track.description[0..11]).to eql('<br />Re-do ')
      expect(post_track.artist_url).to eql('http://modernbaseball.limitedrun.com')
      expect(post_track.popularity).to eql(0)
    end

    it 'should create a valid track post' do
      expect(post_track).to be_valid
    end
  end

  describe '.create', 'no playable content' do
    before do
      @no_playable_content = Post.new(url: (Rails.root + 'spec/support/track/no_playable_content/MicksplosionsBigGiantCircles.html').to_s)
      PostCreator.create(@no_playable_content)
    end

    it 'should not be valid' do
      expect(@no_playable_content).to_not be_valid
    end
  end
end