# a mock data source
class Post
  def self.all
    data = []
    
    3.times { |i|
      data << {
        id: i,
        title: "Post #{i}",
        body: "This is the body for post #{i}."
      }
    }

    data
  end
end
