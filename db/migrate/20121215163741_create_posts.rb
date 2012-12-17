class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :url
      t.string :embed_code

      t.timestamps
    end
  end
end
