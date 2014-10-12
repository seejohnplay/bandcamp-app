class AddArtworkUrlToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :artwork_url, :string
  end
end
