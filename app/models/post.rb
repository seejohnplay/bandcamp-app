require 'open-uri'
require 'nokogiri'

class Post < ActiveRecord::Base
  attr_accessible :embed_code, :url, :link_type, :title, :artist

  has_many :votes

  def vote_number
    votes.where(direction: "up").count - votes.where(direction: "down").count
  end

  def to_param
    "#{id}-#{title.parameterize}-#{artist.parameterize}"
  end

  def set_link_type
    self.link_type = (self.url.include? '/album/') ? 'album' : 'track'
  end

  def get_player_code
    %-<iframe width="400" height="100" style="position: relative; display: block; width: 400px; height: 100px;" src="http://bandcamp.com/EmbeddedPlayer/v=2/#{self.link_type}=#{self.embed_code}/size=venti/bgcol=FFFFFF/linkcol=4285BB/" allowtransparency="true" frameborder="0"></iframe>-
  end

  def extract_album_title(post_url)
    raw_url = open(post_url)
    album_title = ""

    raw_url.each_line do |line|
      if line.include? 'album_title :'
        album_title = line[line.index(':')+3..line.index(',')-2]
        break
      end
    end

    album_title
  end

  def extract_track_title(post_url)
    raw_url = open(post_url)
    album_title = ""

    raw_url.each_line do |line|
      if line.include? 'title :'
        album_title = line[line.index(':')+3..line.index(',')-2]
        break
      end
    end

    album_title
  end

  def set_artist
    raw_url = open(self.url)

    raw_url.each_line do |line|
      if line.include? 'artist :'
        self.artist = line[line.index(':')+3..line.index(',')-2]
        break
      end
    end

    self.album_artist
  end

  def set_embed_code
    #begin
    raw_url = open(self.url)

    raw_url.read.split.each do |line|
      if line.include? 'album='
        self.embed_code =  line.match(/#{self.link_type}=(\d+)/)[1].to_i
        break
      end
    end

    self.embed_code

    #	rescue OpenURI::HTTPError
    #		puts "bad url"
    #	end

  end

end