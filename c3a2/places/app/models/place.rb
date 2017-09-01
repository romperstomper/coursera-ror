class Place
  include Mongoid::Document
  attr_accessor :id, :formatted_address, :location, :address_components
  def initialize(h)
    @id = h[:_id].nil? ? h[:_id] : h[:_id].to_s
    @address_components = h[:address_components].collect { |a| AddressComponent.new(a) }
    @formatted_address = h[:formatted_address]
    @location = Point.new(h[:geometry][:location])
  end
  def self.near(point, max_meters=nil)
    query = {:"geometry.geolocation" => {:$near => {:$geometry => point.to_hash}}}
    query[:"geometry.geolocation"][:$near][:$maxDistance] = max_meters if max_meters
    collection.find(query)
  end
  def self.create_indexes
    collection.indexes.create_one({"geometry.geolocation" => Mongo::Index::GEO2DSPHERE})
  end
  def self.remove_indexes
    collection.indexes.drop_one("geometry.geolocation_2dsphere")
  end
  def self.find_ids_by_country_code(code)
    collection.find.aggregate([
        {:$match => {"address_components.short_name" => code}}, {:$project=>{:_id => 1}}]).to_a.map {|h| h[:_id].to_s}
  end
  def self.get_country_names
    collection.find.aggregate([
        {:$project=>{:_id => 0, "address_components.long_name" => 1, "address_components.types" => 1}}, {:$unwind=>"$address_components"},
        {:$match => {"address_components.types" => "country"}},
        {:$group => {:_id => "$address_components.long_name"}}]).to_a.map {|h| h[:_id]}
  end

  def self.get_address_components(sort=nil, offset=nil, limit=nil)
    prototype = [ {:$unwind=>"$address_components"}, {:$project=>{:_id => 1, :address_components => 1, :formatted_address => 1, "geometry.geolocation" => 1}}]
    prototype << {:$sort => sort} if sort
    prototype << {:$skip => offset} if offset
    prototype << {:$limit => limit} if limit
    collection.find.aggregate(prototype)
  end
  def destroy
    bid = BSON::ObjectId.from_string(@id)
    #puts bid.class
    Place.collection.delete_one(:_id => bid)
  end
  def self.all(offset=0, limit=0)
    p = self.collection.find.skip(offset).limit(limit)
    self.to_places(p.to_a)
  end

  def self.find(s)
    bid = BSON::ObjectId.from_string(s)
    h = self.collection.find(:_id => bid).first
    return h.nil? ? nil : Place.new(h)
  end
  def self.to_places(mcv)
    res = []
    mcv.each do |m|
      res.push(Place.new(m))
    end
    res
  end
  def self.find_by_short_name(q)
    self.collection.find("address_components.short_name" => q)
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
