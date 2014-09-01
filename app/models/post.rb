require 'open-uri'

class Post < ActiveRecord::Base
  validates_uniqueness_of :embed_code, :message => 'has already been imported.'
  validate :url_contains_playable_content

  has_many :votes
  has_many :comments
  acts_as_taggable

  scope :by_created_at, ->(page) { order(created_at: :desc).page(page).per(5) }
  scope :by_tag, ->(tag, page) { tagged_with(tag).by_created_at(page) }

  searchable do
    text :artist
    text :title
  end

  def url_contains_playable_content
    open(self.url).each_line do |line|
      if line.include? 'inline_player'
        return true
      end
    end
    errors.add(:url, 'does not contain playable content.')
  end

  def calculate_popularity
    votes.where(direction: 'up').count - votes.where(direction: 'down').count
  end

  def to_param
    "#{id}-#{title.parameterize}-#{artist.parameterize}"
  end

  def get_player_code
    %-<iframe width="400" height="100" style="position: relative; display: block; width: 400px; height: 100px;" src="http://bandcamp.com/EmbeddedPlayer/v=2/#{self.link_type}=#{self.embed_code}/size=venti/bgcol=FFFFFF/linkcol=4285BB/" allowtransparency="true" frameborder="0"></iframe>-
  end

end