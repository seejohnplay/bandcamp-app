class AddTypeTitleArtistToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :link_type, :string
    add_column :posts, :title, :string
    add_column :posts, :artist, :string
  end
end
