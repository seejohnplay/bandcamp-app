class AddDescriptionAndArtistUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :description, :text
    add_column :posts, :artist_url, :string
  end
end
