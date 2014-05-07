require 'yelp'

module Lita
  module Handlers
  class Yelpme < Handler
  	route(/^(?:yelp|y)\s+(.+)/u, :yelp, command: true, help: {
      "yelp QUERY" => "Return the first Yelp result with information about the first business found"
    })
    def self.default_config(handler_config)
	handler_config.consumer_key = nil
	handler_config.consumer_secret = nil
	handler_config.token = nil
	handler_config.token_secret = nil
	handler_config.default_city = "San Francisco"
    end
    def yelp(response)
      query = response.matches[0][0]
      client = Yelp::Client.new({ consumer_key: config.yelpme.consumer_key,
               consumer_secret: config.yelpme.consumer_secret,
               token: config.yelpme.token,
               token_secret: config.yelpme.token_secret
            })
      yelp_response = client.search(config.default_city, { term: query, limit: 1 })
      if len(yelp_response.businesses) == 0
	response.reply('Cannot find any businesses in #{config.default_city} matching #{query}')
      end
      result = yelp_response.businesses[0]
      address = "#{result.location.address.join(' ')}, #{result.location.city}, #{result.location.state_code} #{result.location.postal_code}"
      response.reply("#{result.name} (#{result.rating} from #{result.review_count} reviews) @ #{address} - #{result.display_phone} #{result.url}")
    end
  end

  Lita.register_handler(Yelpme)
  end
end
