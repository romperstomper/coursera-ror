require 'httparty'
require 'pp'

#'6ce007e21bbdb178ff7f6217aaadeb97'
#url = "#{hostport}/api/search?key=#{key_value}&q=#{keyword}"
##< ActiveRecord::Base
#default_params key: key_value
#format :json
#hostport = 'www.food2fork.com'

class Recipe 
  include HTTParty
  base_uri = 'http://www.food2fork.com/api'
  def self.for
    get('/search', query: { 'key' => '6ce007e21bbdb178ff7f6217aaadeb97' })
  end
end

pp Recipe.for
