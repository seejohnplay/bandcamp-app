class Search
  attr_reader :term

  def initialize term
    @term = term
  end

  def posts
    Post.search do
      fulltext term
    end.results
  end
end