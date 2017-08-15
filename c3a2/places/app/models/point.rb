class Point
  include Mongoid::Document
  attr_accessor :latitude, :longitude

  def initialize(h)
    if h[:lat]
      @latitude = h[:lat]
      @longitude = h[:lng]
    else
      @latitude = h[:coordinates][1]
      @longitude = h[:coordinates][0]
    end
  end
  def to_hash
    {type: "Point", coordinates: [@longitude, @latitude]}
  end
end
