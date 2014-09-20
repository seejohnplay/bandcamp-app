require 'open-uri'
require 'nokogiri'

class PostCreator

  attr_accessor :post, :doc

  class << self
    def create post
      @post = post
      begin
        set_post_type
        @post.soundcloud? ? "PostCreator#{@post.post_type}".constantize.set_post_attributes(@post) : set_post_attributes
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

    def set_post_attributes
      open_url

      @post.link_type = (@post.url.include? '/track/') ? 'track' : 'album'
      @post.embed_code = @doc.xpath('//comment()').last.to_s.match(/(\d+)/)[1].to_i
      @post.description = @doc.at_xpath("//meta[@name='Description']/@content").to_s.gsub("\n", '<br />')
      @post.artist_url = @doc.at_css("span[@itemprop='byArtist'] a @href").to_s
      @post.title = title_tag[title_tag.index('<title>')+7..title_tag.index('|')-2]
      @post.artist = title_tag[title_tag.index('|')+2..title_tag.index('</title>')-1]
      set_tags
    end

    def open_url
      post_url = @post.url.starts_with?('/') ? @post.url : @post.url + '/' # add a trailing slash if needed
      @doc = Nokogiri::HTML(open(post_url), nil, 'utf-8')
    end

    def title_tag
      @doc.search('title').to_s
    end

    def set_tags
      @doc.css("a[@class=tag]").each { |tag| @post.tag_list.add(tag.text) }
      @post.tag_list.add(@post.artist.downcase) if @post.artist
    end
  end
end