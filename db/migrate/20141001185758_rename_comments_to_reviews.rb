class RenameCommentsToReviews < ActiveRecord::Migration
  def change
    rename_table :reviews, :reviews
  end
end
