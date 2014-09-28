class AddDraftToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :draft, :boolean, :default => false
  end
end
