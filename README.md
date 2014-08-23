# lita-yelpme
[![Build Status](https://img.shields.io/travis/twexler/lita-yelpme/master.svg)](https://travis-ci.org/twexler/lita-yelpme)
[![Coverage Status](https://img.shields.io/coveralls/twexler/lita-yelpme.svg)](https://coveralls.io/r/twexler/lita-yelpme?branch=master)

## Installation

Add lita-yelpme to your Lita instance's Gemfile:

``` ruby
gem "lita-yelpme"
```


## Configuration

lita-yelpme requires a Yelp API key. You can get from the [Yelp Developer Page](http://www.yelp.com/developers)

Add the following variables to your Lita config file:

``` ruby
config.handlers.yelpme.consumer_secret = 'CONSUMER_SECRET'
config.handlers.yelpme.consumer_key = 'CONSUMER_KEY'
config.handlers.yelpme.token = 'TOKEN_KEY'
config.handlers.yelpme.token_secret = 'TOKEN_SECRET'
```

## Usage

``` yelp State Bird Provisions ```

## License

[MIT](http://opensource.org/licenses/MIT)
