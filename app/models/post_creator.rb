require 'open-uri'
require 'nokogiri'

class PostCreator

  attr_accessor :post, :doc

  class << self
    def create post
      @post = post
      begin
        open_doc
        set_post_attributes
      rescue
        @post.errors.add :base, 'Something went wrong. Please make sure you\'re submitting a valid Bandcamp URL containing playable audio.'
        return false
      end
      @post
    end

    private

    def open_doc
      post_url = @post.url.starts_with?('/') ? @post.url : @post.url + '/' # add a trailing slash if needed
      @doc = Nokogiri::HTML(open(post_url), nil, 'utf-8')
    end

    def set_post_attributes
      set_link_type
      set_title_and_artist
      set_embed_code
      set_tags
      set_description
      set_artist_url
    end

    def set_link_type
      @post.link_type = (@post.url.include? '/track/') ? 'track' : 'album'
    end

    def set_title_and_artist
      title_tag = @doc.search('title').to_s

      @post.title = title_tag[title_tag.index('<title>')+7..title_tag.index('|')-2]
      @post.artist = title_tag[title_tag.index('|')+2..title_tag.index('</title>')-1]
      #@post.artist = doc.css("p").css("span[class=title]").text
    end

    def set_embed_code
      @post.embed_code = @doc.xpath('//comment()').last.to_s.match(/(\d+)/)[1].to_i
      #@post.embed_code = doc.xpath("//meta[@property='twitter:player']/@content").text.match(/#{@post.link_type}=(\d+)/)[1].to_i
    end

    def set_tags
      @doc.css("a[@class=tag]").each { |tag| @post.tag_list.add(tag.text) }
      @post.tag_list.add(@post.artist.downcase) if @post.artist
    end

    def set_description
      @post.description = @doc.at_xpath("//meta[@name='Description']/@content").to_s.gsub("\n", '<br />')
    end

    def set_artist_url
      @post.artist_url = @doc.at_css("span[@itemprop='byArtist'] a @href").to_s
    end
  end
end