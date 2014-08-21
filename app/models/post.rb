require 'open-uri'
require 'nokogiri'

class Post < ActiveRecord::Base
  #attr_accessible :embed_code, :url, :link_type, :title, :artist, :description, :artist_url
  validates :embed_code, :url, :link_type, :title, :artist, presence: true
  validates_uniqueness_of :embed_code, :message => 'has already been imported.'

  has_many :votes
  has_many :comments
  acts_as_taggable

  scope :by_created_at, ->(page) { order(created_at: :desc).page(page).per(5) }
  scope :by_tag, ->(tag, page) { tagged_with(tag).by_created_at(page) }

  def calculate_popularity
    votes.where(direction: "up").count - votes.where(direction: "down").count
  end

  def to_param
    "#{id}-#{title.parameterize}-#{artist.parameterize}"
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

  def setup

    self.set_link_type
    self.set_artist_title_embed_code_and_tags
    self.set_description_and_artist_url

  end

  def set_link_type
    self.link_type = (self.url.include? '/track/') ? 'track' : 'album'
  end

  def set_artist_title_embed_code_and_tags
    post_url = open(self.url)
    post_url.each_line do |line|
      case line
        when /<title>/
          self.title = line[line.index('<title>')+7..line.index('|')-2]
        when /artist :/
          self.artist = line[line.index(':')+3..line.index(',')-2]
        when /#{self.link_type}=/
          self.embed_code = line.match(/#{self.link_type}=(\d+)/)[1].to_i
        when /\/tag\//
          tag = line.match(/\/tag\/(\w+)/)[1]
          self.tag_list.add(tag)
      end
    end
    self.tag_list.add(self.artist.downcase)
  end

  def set_description_and_artist_url
    doc = Nokogiri::HTML(open(self.url), nil, 'utf-8')
    self.description = doc.at_xpath("//meta[@name='Description']/@content").to_s.gsub("\n", '<br />')
    self.artist_url = doc.at_css("span[@itemprop='byArtist'] a @href").to_s
  end

end