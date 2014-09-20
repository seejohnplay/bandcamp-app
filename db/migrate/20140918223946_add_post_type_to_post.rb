class AddPostTypeToPost < ActiveRecord::Migration
  def up
    add_column :posts, :post_type, :string
    Post.update_all(post_type: 'Soundcloud')
  end

  def down
    remove_column :posts, :post_type
  end
end
