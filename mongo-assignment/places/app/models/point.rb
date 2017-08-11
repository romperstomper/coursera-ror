class Point
  include Mongoid::Document
  attr_accessor :longitude, :latitude

  def initialize(h)
    if h[:lat]
      @longitude = h[:lng]
      @latitude = h[:lat]
    else
      @longitude = h[:coordinates][0]
      @latitude = h[:coordinates][1]
    end
  end
  def to_hash
    #{'type': 'Point', 
     #'coordinates': [self.longitude, self.latitude]}
  end
end
