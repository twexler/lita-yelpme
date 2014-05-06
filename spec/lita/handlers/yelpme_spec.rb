require "spec_helper"

describe Lita::Handlers::Yelpme, lita_handler: true do
  let(:api_keys) { {
    consumer_key: ENV['YELP_CONSUMER_KEY'],
    consumer_secret: ENV['YELP_CONSUMER_SECRET'],
    token: ENV['YELP_TOKEN'],
    token_secret: ENV['YELP_TOKEN_SECRET'],
  } }
  let(:result) {
    client = Yelp::Client.new("foo")
    client.search("San Francisco", { term: "state bird provisions"})
  }
  before do
    allow_any_instance_of(Yelp::Client).to receive(:search).and_return(:result)
  end
  it { routes_command('yelp state bird provisions').to(:yelp) }

  it "fetches a result from yelp" do
    send_command("yelp state bird provisions")
    expect(replies.last).to eq ("State Bird Provisions (4.5 from 787 reviews) @ 1529 Fillmore St, San Francisco, CA 94115 - +1-415-795-1272 http://www.yelp.com/biz/state-bird-provisions-san-francisco")
  end
end
