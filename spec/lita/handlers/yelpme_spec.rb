require "spec_helper"

describe Lita::Handlers::Yelpme, lita_handler: true do
  it { is_expected.to route_command('yelp state bird provisions').to(:yelp)}
  it { is_expected.to route_command('yelp original gravity @ san jose').to(:yelp_city) }

  describe "without valid API keys" do
    it "returns an error when no api keys are defined" do
      send_command("yelp state bird provisions")
      expect(replies.last).to eq ("Sorry, could not fetch a response from Yelp")
    end
  end

  describe "with valid API keys" do

    before do
      allow(Yelp::Client).to receive(:new) { Yelp::Client }
      allow(Yelp::Client).to receive(:search) { yelp_response }
    end
    describe "using the default city" do
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
      it "fetches a result from yelp" do
        send_command("yelp state bird provisions")
        expect(replies.last).to eq ("State Bird Provisions (4.5 from 787 reviews) @ 1529 Fillmore St, San Francisco, CA 94115 - +1-415-795-1272 http://www.yelp.com/biz/state-bird-provisions-san-francisco")
      end
    end
    describe "using the specified city" do
      let(:yelp_response) {
        BurstStruct::Burst.new({
            businesses: [
              {
                location: {
                  city: "San Jose",
                  address: ["66", "S", "1st", "St"],
                  state_code: "CA",
                  postal_code: "95113"
                },
                name: "Original Gravity Public House",
                rating: "4.0",
                review_count: 348,
                display_phone: "+1-408-915-2337",
                url: "http://www.yelp.com/biz/original-gravity-public-house-san-jose"
              }
            ]
        })
      }
      it "fetches a result from the specified city" do
        send_command('yelp original gravity @ san jose')
        expect(replies.last).to eq ("Original Gravity Public House (4.0 from 348 reviews) @ 66 S 1st St, San Jose, CA 95113 - +1-408-915-2337 http://www.yelp.com/biz/original-gravity-public-house-san-jose")
      end
    end
    describe "if there are no results" do
      let(:yelp_response) {
        BurstStruct::Burst.new({
            businesses: []
        })
      }
      it "returns an error" do
        send_command("yelp fhaskjlfhaskfhdaskjlgflaskjhdalkhflaksjhfsa")
        expect(replies.last).to eq("Cannot find any businesses in San Francisco matching fhaskjlfhaskfhdaskjlgflaskjhdalkhflaksjhfsa")
      end
    end
  end
end
