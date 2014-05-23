require "spec_helper"

describe Lita::Handlers::Yelpme, lita_handler: true do
  it { routes_command('yelp state bird provisions').to(:yelp) }

  describe "without valid API keys" do
    it "returns an error when no api keys are defined" do
      send_command("yelp state bird provisions")
      expect(replies.last).to eq ("Sorry, could not fetch a response from Yelp")
    end
  end

  describe "with valid API keys" do
    let(:yelp_response) {
        BurstStruct::Burst.new({
          businesses: [
            {
              location: {
                city: "San Francisco",
                address: ["1529", "Fillmore", "St"],
                state_code: "CA",
                postal_code: "94115"
              },
              name: "State Bird Provisions",
              rating: "4.5",
              review_count: 787,
              display_phone: "+1-415-795-1272",
              url: "http://www.yelp.com/biz/state-bird-provisions-san-francisco"
            }
          ]
      })
    }
    before do
      allow(Yelp::Client).to receive(:new) { Yelp::Client }
      allow(Yelp::Client).to receive(:search) { yelp_response }
    end
    it "fetches a result from yelp" do
      send_command("yelp state bird provisions")
      expect(replies.last).to eq ("State Bird Provisions (4.5 from 787 reviews) @ 1529 Fillmore St, San Francisco, CA 94115 - +1-415-795-1272 http://www.yelp.com/biz/state-bird-provisions-san-francisco")
    end
  end
end
