require 'lita'
require 'yelp'

module Lita
  module Handlers
    class Yelpme < Handler
    	route(/^(?:yelp|y)\s+(.+)/u, :yelp, command: true, help: {
            "yelp QUERY" => "Return the first Yelp result with information about the first business found"
        })
	    def self.default_config(handler_config)
	    	handler_config.consumer_key = ENV['YELP_CONSUMER_KEY']
	    	handler_config.consumer_secret = ENV['YELP_CONSUMER_SECRET']
	    	handler_config.token =  ENV['YELP_TOKEN']
	    	handler_config.token_secret =  ENV['YELP_TOKEN_SECRET']
	    	handler_config.default_city = "San Francisco"
	    end
        def yelp(response)
            query = response.matches[0][0]
            client = Yelp::Client.new({ consumer_key: Lita.config.handlers.yelpme.consumer_key,
                           consumer_secret: Lita.config.handlers.yelpme.consumer_secret,
                           token: Lita.config.handlers.yelpme.token,
                           token_secret: Lita.config.handlers.yelpme.token_secret
                        })
            yelp_response = client.search(config.default_city, { term: query, limit: 1 })
            result = yelp_response.businesses[0]
            address = "#{result.location.address.join(' ')}, #{result.location.city}, #{result.location.state_code} #{result.location.postal_code}"
            response.reply("#{result.name} (#{result.rating} from #{result.review_count} reviews) @ #{address} - #{result.display_phone} #{result.url}")
        end
    end

    Lita.register_handler(Yelpme)
  end
end
