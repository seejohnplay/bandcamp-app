class AddPopularityToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :popularity, :integer, :null => false, :default => 0
  end
end
