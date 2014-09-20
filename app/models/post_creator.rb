require 'open-uri'
require 'nokogiri'

class PostCreator

  attr_accessor :post

  class << self
    def create post
      @post = post
      begin
        set_post_type
        "PostCreator#{@post.post_type}".constantize.set_post_attributes(@post)
      rescue
        @post.errors.add :base, 'Something went wrong. Please make sure you\'re submitting a valid Bandcamp or Soundcloud URL containing playable audio.'
        return false
      end
      @post
    end

    private

    def set_post_type
      @post.soundcloud? ? @post.post_type = 'Soundcloud' : @post.post_type = 'Bandcamp'
    end
  end
end