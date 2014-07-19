require 'open-uri'
require 'nokogiri'

class Post < ActiveRecord::Base
  attr_accessible :embed_code, :url, :link_type, :title, :artist
  validates :embed_code, :url, :link_type, :title, :artist, presence: true
  validates_uniqueness_of :url, :message => 'has already been imported.'

  has_many :votes
  acts_as_taggable

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

  def playable?
    raw_url = open(self.url)

    raw_url.each_line do |line|
      if line.include? 'inline_player'
        return true
        break
      end
    end

    false
  end

  def set_title
    raw_url = open(self.url)

    raw_url.each_line do |line|
      if line.include? '<title>'
        self.title = line[line.index('<title>')+7..line.index('|')-2]
        break
      end
    end

    self.title
  end

  def set_artist
    raw_url = open(self.url)

    raw_url.each_line do |line|
      if line.include? 'artist :'
        self.artist = line[line.index(':')+3..line.index(',')-2]
        break
      end
    end

    self.artist
  end

  def set_embed_code
    raw_url = open(self.url)

    raw_url.read.split.each do |line|
      if line.include? "#{self.link_type}="
        self.embed_code = line.match(/#{self.link_type}=(\d+)/)[1].to_i
        break
      end
    end

    self.embed_code
  end

  def set_tags
    raw_url = open(self.url)

    raw_url.read.split.each do |line|
      if line.include? '/tag/'
        tag = line.match(/\/tag\/(\w+)/)[1]
        self.tag_list.add(tag)
      end
    end
    self.tag_list.add(self.artist.downcase)

    self.tag_list
  end

end