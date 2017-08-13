class Place
  include Mongoid::Document
  def self.mongo_client
    Mongoid::Clients.default
  end
  def self.collection
    self.mongo_client[:places]
  end
  def self.load_all(fd)
    data = File.read(fd)
    h = JSON.parse(data)
    self.collection.insert_many(h)
  end
end
