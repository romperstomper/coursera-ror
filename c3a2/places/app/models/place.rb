class Place
  include Mongoid::Document
  attr_accessor :id, :formatted_address, :location, :address_components
  def initialize(h)
    @id = h[:_id].to_s
    @address_components = h[:address_components].collect { |a| AddressComponent.new(a) }
    @formatted_address = h[:formatted_address]
    @location = Point.new(h[:geometry][:location])
  end
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
