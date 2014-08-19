require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = Post.new(url: (Rails.root + 'test/support/album/HeadZirkusMissWalker.html').to_s)
    @post.setup
  end

  test 'setup should properly extract attributes from HTML Bandcamp album page' do
    assert @post.save
  end

  test 'having two posts with the same embed code isn\'t allowed' do
    assert @post.save

    post2 = Post.new(url: (Rails.root + 'test/support/album/HeadZirkusMissWalker.html').to_s)
    post2.setup
    assert !post2.save
  end

  test 'setup should properly extract attributes from HTML Bandcamp single track page' do
    post = Post.new(url: (Rails.root + 'test/support/track/RedoModernBaseball.html').to_s)
    post.setup
    assert post.save
  end
end