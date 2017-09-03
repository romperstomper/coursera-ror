class Place
  include ActiveModel::Model

  attr_accessor :id, :formatted_address, :location, :address_components

  def initialize(hash={})
    @id = hash[:_id].nil? ? hash[:id] : hash[:_id].to_s
    @formatted_address = hash[:formatted_address]
    @location = Point.new(hash[:geometry][:geolocation])
    if !hash[:address_components].nil?
      @address_components = hash[:address_components].map { |a| AddressComponent.new(a) }
    end
  end

  def persisted?
    !@id.nil?
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def self.collection
    mongo_client[:places]
  end

  def self.load_all(file)
    docs = JSON.parse(file.read)
    collection.insert_many(docs)
  end

  def self.find_by_short_name(short_name)
    collection.find(:'address_components.short_name' => short_name)
  end

  def self.find(id)
    id = BSON::ObjectId.from_string(id)
    doc = collection.find(:_id => id).first

    return doc.nil? ? nil : Place.new(doc)
  end

  def self.all(offset=0, limit=nil)
    result = collection.find({}).skip(offset)
    result = result.limit(limit) if !limit.nil?
    result = to_places(result)
  end

  def destroy
    id = BSON::ObjectId.from_string(@id)
    self.class.collection.delete_one(:_id => id)
  end

  # Helper function
  def self.to_places(places)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.get_address_components(sort=nil, offset=nil, limit=nil)
    prototype = [
      {
        :$unwind => '$address_components'
      },
      {
        :$project => {
          :address_components => 1,
          :formatted_address => 1,
          :'geometry.geolocation' => 1
        }
      }
    ]

    prototype << {:$sort => sort} if !sort.nil?
    prototype << {:$skip => offset} if !offset.nil?
    prototype << {:$limit => limit} if !limit.nil?

    collection.find.aggregate(prototype)
  end

  def self.get_country_names
    result = collection.find.aggregate([
      {
        :$project => {
          :_id => 0,
          :'address_components.long_name' => 1,
          :'address_components.types' => 1
        }
      },
      {
        :$unwind => '$address_components'
      },
      {
        :$match => {
          :'address_components.types' => 'country'
        }
      },
      {
        :$group => {
          :_id => '$address_components.long_name'
        }
      }
    ])

    result.to_a.map { |doc| doc[:_id] }
  end

  def self.find_ids_by_country_code(country_code)
    result = collection.find.aggregate([
      {
        :$match => {
          :'address_components.types' => 'country',
          :'address_components.short_name' => country_code
        }
      },
      {
        :$project => {
          :_id => 1
        }
      }
    ])

    result.map { |doc| doc[:_id].to_s }
  end

  def self.create_indexes
    collection.indexes.create_one(:'geometry.geolocation' => Mongo::Index::GEO2DSPHERE)
  end

  def self.remove_indexes
    collection.indexes.drop_one('geometry.geolocation_2dsphere')
  end

  def self.near(point, max_meters=nil)
    query = {
      :'geometry.geolocation' => {
        :$near => {
          :$geometry => point.to_hash,
          :$maxDistance => max_meters
        }
      }
    }
    collection.find(query)
  end

  def near(max_meters=nil)
    result = self.class.near(@location, max_meters)
    self.class.to_places(result)
  end

  def photos(offset=0, limit=nil)
    result = []
    photos = Photo.find_photos_for_place(@id).skip(offset)
    photos = photos.limit(limit) if !limit.nil?

    if photos.count
      photos.map do |photo|
        result << Photo.new(photo)
      end
    end

    return result
  end
end
