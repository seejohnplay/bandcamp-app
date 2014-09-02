module PostsHelper
  def post_tags
    Post.tag_counts_on(:tags)
  end
end