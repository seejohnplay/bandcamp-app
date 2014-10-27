require 'open-uri'
require 'elasticsearch/model'

class Post < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  before_validation(on: :create) do
    PostCreator.create(self)
  end

  validates_uniqueness_of :embed_code, :message => 'has already been imported.'
  validates_presence_of :artist, :title
  validate :url_contains_playable_content

  has_many :votes
  has_many :reviews
  has_many :ratings, -> { where("score > ?", 0) }
  acts_as_taggable

  scope :by_created_at, ->(page) { order(created_at: :desc).page(page).per(5) }
  scope :by_tag, ->(tag, page) { tagged_with(tag).by_created_at(page) }

  def url_contains_playable_content
    if self.post_type == 'Bandcamp'
      open(self.url).each_line do |line|
        if line.include? 'inline_player'
          return true
        end
      end
      errors.add(:url, 'does not contain playable content.')
    else
      true
    end
  end

  def calculate_popularity
    votes.where(direction: 'up').count - votes.where(direction: 'down').count
  end

  def to_param
    "#{id}-#{title.parameterize}-#{artist.parameterize}"
  end

  def player_code
    if self.soundcloud?
      %-<iframe width="400" height="110" scrolling="no" frameborder="no" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/#{self.link_type}s/#{self.embed_code}&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_user=true&amp;show_reposts=false&amp;visual=false"></iframe>-
    else
      %-<iframe width="400" height="100" style="position: relative; display: block; width: 400px; height: 100px;" src="http://bandcamp.com/EmbeddedPlayer/v=2/#{self.link_type}=#{self.embed_code}/size=venti/bgcol=FFFFFF/linkcol=4285BB/" allowtransparency="true" frameborder="0"></iframe>-
    end
  end

  def reviews_for(user)
    if user && user.admin?
      self.reviews.includes(:user)
    elsif user
      self.reviews.where(user_id: user.id)
    else
      []
    end
  end

  def average_rating
    ratings.sum(:score) / (ratings.size.nonzero? || 1).to_f
  end

  def soundcloud?
    self.url.include?('soundcloud')
  end
end

Post.import # for elasticsearch