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

  def set_link_type(post_url)
  	if post_url.include? '/album/'
  		return 'album'
  	else
  		return 'track'
  	end
  end

  def get_player_code(post)

  	if post.url.include? '/album/'
			album_id_code = "album=#{post.embed_code}"
		else
			album_id_code = "track=#{post.embed_code}"
		end

		%-<iframe width="400" height="100" style="position: relative; display: block; width: 400px; height: 100px;" src="http://bandcamp.com/EmbeddedPlayer/v=2/#{album_id_code}/size=venti/bgcol=FFFFFF/linkcol=4285BB/" allowtransparency="true" frameborder="0"></iframe>-

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

  def extract_album_artist(post_url)
		raw_url = open(post_url)
		album_artist = ""

		raw_url.each_line do |line|
			if line.include? 'artist :'
				album_artist = line[line.index(':')+3..line.index(',')-2]
				break
			end
		end

		album_artist
  end

	def get_album_id(post_url)
		#begin
		raw_url = open(post_url)
		album_id = ""

		raw_url.read.split.each do |line|
			if line.include? 'album='
				album_id = line.match(/\d+/).to_s.to_i
				break
			end
		end

	album_id

	#	rescue OpenURI::HTTPError
	#		puts "bad url"
	#	end

end

	def get_track_id(post_url)
		
		raw_url = open(post_url)
		track_id = ""

		raw_url.read.split.each do |line|
			if line.include? 'track='
				track_id = line.match(/\d+/).to_s.to_i
				break
			end
		end

		track_id
	end

end