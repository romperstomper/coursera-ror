class Photo
  require 'exifr/jpeg'
  attr_accessor :id, :location
  attr_writer :contents

  def initialize(hash={})
    @id = hash[:_id].to_s if !hash[:_id].nil?
    if !hash[:metadata].nil?
      @location = Point.new(hash[:metadata][:location]) if !hash[:metadata][:location].nil?
      @place = hash[:metadata][:place]
    end
  end

  def self.mongo_client
    Mongoid::Clients.default
  end

  def persisted?
    !@id.nil?
  end

  def save
    if !persisted?
      gps = EXIFR::JPEG.new(@contents).gps
      description = {}
      description[:content_type] = 'image/jpeg'
      description[:metadata] = {}
      @location = Point.new(:lng => gps.longitude, :lat => gps.latitude)
      description[:metadata][:location] = @location.to_hash
      description[:metadata][:place] = @place

      if @contents
        @contents.rewind
        grid_file = Mongo::Grid::File.new(@contents.read, description)
        id = self.class.mongo_client.database.fs.insert_one(grid_file)
        @id = id.to_s
      end
    else
      self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId(@id))
        .update_one(:$set => {
          :metadata => {
            :location => @location.to_hash,
            :place => @place
          }
        })
    end
  end

  def self.all(skip=0, limit=nil)
    docs = mongo_client.database.fs.find({})
      .skip(skip)
    docs = docs.limit(limit) if !limit.nil?

    docs.map do |doc|
      Photo.new(doc)
    end
  end

  def self.find(id)
    doc = mongo_client.database.fs.find(:_id => BSON::ObjectId(id)).first
    return doc.nil? ? nil : Photo.new(doc)
  end

  def contents
    doc = self.class.mongo_client.database.fs.find_one(:_id => BSON::ObjectId(@id))
    if doc
      buffer = ""
      doc.chunks.reduce([]) do |x, chunk|
        buffer << chunk.data.data
      end
      return buffer
    end
  end

  def destroy
    self.class.mongo_client.database.fs.find(:_id => BSON::ObjectId(@id)).delete_one
  end

  def find_nearest_place_id(max_distance)
    place = Place.near(@location, max_distance)
      .limit(1)
      .projection(:_id => 1)
      .first

    return place.nil? ? nil : place[:_id]
  end

  def place
    if !@place.nil?
      Place.find(@place.to_s)
    end
  end

  def place=(place)
    if place.class == Place
      @place = BSON::ObjectId.from_string(place.id)
    elsif place.class == String
      @place = BSON::ObjectId.from_string(place)
    else
      @place = place
    end
  end

  def self.find_photos_for_place(place_id)
    place_id = BSON::ObjectId.from_string(place_id.to_s)
    mongo_client.database.fs.find(:'metadata.place' => place_id)
  end
end
