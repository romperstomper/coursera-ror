class Place
  include Mongoid::Document
  def self.load_all(fd)
    data = IO.read(fd)
    h = JSON.parse(data)
    self.collection.insert_many(h)
  end
end
