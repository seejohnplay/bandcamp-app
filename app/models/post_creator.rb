require 'open-uri'
require 'nokogiri'

class PostCreator

  attr_accessor :post

  class << self
    def create post
      @post = post
      begin
        set_link_type
        set_artist_title_embed_code_and_tags
        set_description_and_artist_url
      rescue
        @post.errors.add :base, 'Something went wrong. Please make sure you\'re submitting a valid Bandcamp URL containing playable audio.'
        return false
      end
      @post.save
    end

    private

    def set_link_type
      @post.link_type = (@post.url.include? '/track/') ? 'track' : 'album'
    end

    def set_artist_title_embed_code_and_tags
      open(@post.url).each_line do |line|
        case line
          when /<title>/
            @post.title = line[line.index('<title>')+7..line.index('|')-2]
          when /artist :/
            @post.artist = line[line.index(':')+3..line.index(',')-2]
          when /#{@post.link_type}=/
            @post.embed_code = line.match(/#{@post.link_type}=(\d+)/)[1].to_i
          when /\/tag\//
            tag = line.match(/\/tag\/(\w+)/)[1]
            @post.tag_list.add(tag)
        end
      end
      @post.tag_list.add(@post.artist.downcase) if @post.artist
    end

    def set_description_and_artist_url
      post_url = @post.url.starts_with?('/') ? @post.url : @post.url + '/' # add a trailing slash if needed
      doc = Nokogiri::HTML(open(post_url), nil, 'utf-8')
      @post.description = doc.at_xpath("//meta[@name='Description']/@content").to_s.gsub("\n", '<br />')
      @post.artist_url = doc.at_css("span[@itemprop='byArtist'] a @href").to_s
    end
  end
end