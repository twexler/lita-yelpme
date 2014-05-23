require 'yelp'

module Lita
  module Handlers
  class Yelpme < Handler
  	route(/^(?:yelp|y)\s+(.+)/u, :yelp, command: true, help: {
      "yelp QUERY" => "Return the first Yelp result with information about the first business found"
    })

    def self.default_config(handler_config)
      handler_config.default_city = "San Francisco"
    end

    def yelp(response)
      query = response.matches[0][0]
      begin
        yelp_response = client.search(config.default_city, { term: query, limit: 1 })
      rescue Yelp::Error::MissingAPIKeys
        Lita.logger.error('Could not receive response from yelp, check your API keys')
        response.reply('Sorry, could not fetch a response from Yelp')
        return
      end
      if yelp_response.businesses.length == 0
        response.reply('Cannot find any businesses in #{config.default_city} matching #{query}')
      end
      result = yelp_response.businesses[0]
      address = "#{result.location.address.join(' ')}, #{result.location.city}, #{result.location.state_code} #{result.location.postal_code}"
      response.reply("#{result.name} (#{result.rating} from #{result.review_count} reviews) @ #{address} - #{result.display_phone} #{result.url}")
    end

    def client
      Yelp::Client.new(
        consumer_key: config.consumer_key,
        consumer_secret: config.consumer_secret,
        token: config.token,
        token_secret: config.token_secret
      )
    end
  end

  Lita.register_handler(Yelpme)
  end
end
