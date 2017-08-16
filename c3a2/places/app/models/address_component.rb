class AddressComponent
  include Mongoid::Document
  attr_reader :long_name, :short_name, :types

  def initialize(h)
    @long_name = h[:long_name]
    @short_name = h[:short_name]
    @types = h[:types]
  end
end
