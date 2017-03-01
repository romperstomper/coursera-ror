require 'httparty'

#'6ce007e21bbdb178ff7f6217aaadeb97'
#url = "#{hostport}/api/search?key=#{key_value}&q=#{keyword}"
#default_params key: key_value
#format :json
#hostport = 'www.food2fork.com'

class Recipe < ActiveRecord::Base
  include HTTParty
  hostport = ENV['FOOD2FORK_SERVER_AND_PORT'] || 'www.food2fork.com'
  base_uri "http://#{hostport}/api"
  default_params key: ENV['FOOD2FORK_KEY']
  format :json
  def self.for(search)
    get("/search", query: { q: search})["recipes"]
  end
end
