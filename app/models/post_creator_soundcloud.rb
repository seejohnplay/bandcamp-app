require 'soundcloud'

class PostCreatorSoundcloud

  attr_accessor :post, :track

  class << self
    def set_post_attributes post
      @post = post

      open_url

      @post.description = @track.description.gsub("\n", '<br />')
      @post.link_type = @track.kind
      @post.title = @track.title
      @post.artist = @track.user.username
      @post.embed_code = @track.id

      set_tags
    end

    private

    def open_url
      client = Soundcloud.new(:client_id => ENV['SOUNDCLOUD_CLIENT_ID'])
      @track = client.get('/resolve', :url => @post.url)
    end

    def set_tags
      tags = (CSV::parse_line(@track.tag_list, col_sep: ' ') if @track.tag_list) || []
      tags << @track.genre
      tags << @track.user.username
      tags.map!(&:downcase)

      tags.each { |tag| @post.tag_list.add(tag) }
    end
  end
end