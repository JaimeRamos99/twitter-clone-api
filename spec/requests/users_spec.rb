require "rails_helper"
RSpec.describe "Tweets", type: :request do

  describe "/tweets, listing my own tweets and the tweets of my following" do
    context "a user without tweets and not following anyone" do
      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
      before { get '/tweets', params: {}, headers: auth_headers}
      it "should return OK and empty" do
        payload = JSON.parse(response.body)
        expect(payload["tweets"]).to be_empty
        expect(response).to have_http_status(200)
      end
    end

    context "listing my tweets and/or my following tweets" do
      let!(:user11) { create(:user) }
      let!(:auth_headers11) { { 'Authorization' => "Bearer #{user11.auth_token}" } }

      let!(:user22) { create(:user) }
      let!(:auth_headers22) { { 'Authorization' => "Bearer #{user22.auth_token}" } }

      let!(:user33) { create(:user) }
      let!(:auth_headers33) { { 'Authorization' => "Bearer #{user33.auth_token}" } }

      let!(:user1_tweet1) { create(:tweet, user: user11) }
      let!(:user2_tweet1) { create(:tweet, user: user22) }
      let!(:user2_tweet2) { create(:tweet, user: user22) }
      let!(:user3_tweet1) { create(:tweet, user: user33) }


      before { post "/follow", params: {"followed": user22.username}, headers: auth_headers11 }
      before { post "/follow", params: {"followed": user33.username}, headers: auth_headers11 }


      before { post "/tweet", params: {"content": user1_tweet1.content}, headers: auth_headers11 }
      before { post "/tweet", params: {"content": user2_tweet1.content}, headers: auth_headers22 }
      before { post "/tweet", params: {"content": user2_tweet2.content}, headers: auth_headers22 }
      before { post "/tweet", params: {"content": user3_tweet1.content}, headers: auth_headers33 }


      before { get '/tweets', params: {}, headers: auth_headers11}

      it "should return OK and empty" do
        payload = JSON.parse(response.body)
        #the division is because the tweets are repeated twice
        expect(payload["tweets"].size/2).to  eq(4)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "/followers list followers of a user" do
    context "User without followers" do
      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
      before { get '/followers', params: {}, headers: auth_headers}
      it "should return OK and empty" do
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(200)
      end
    end

    context "User with followers" do
      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }

      let!(:user1) { create(:user) }
      let!(:auth_headers1) { { 'Authorization' => "Bearer #{user1.auth_token}" } }

      let!(:user2) { create(:user) }
      let!(:auth_headers2) { { 'Authorization' => "Bearer #{user2.auth_token}" } }

      before { post "/follow", params: {"followed": user.username}, headers: auth_headers1 }
      before { post "/follow", params: {"followed": user.username}, headers: auth_headers2 }

      before { get '/followers', params: {}, headers: auth_headers}

      it "should return my own tweets" do
        payload = JSON.parse(response.body)
        expect(payload.size).to eq(2)
        expect(response).to have_http_status(200)
      end

    end
  end

  describe "/follows list users, the current user is following" do

      context "User without follows" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        before { get '/follows', params: {}, headers: auth_headers}
        it "should return OK" do
          payload = JSON.parse(response.body)
          expect(payload).to be_empty
          expect(response).to have_http_status(200)
        end
      end

      context "User with follows" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }

        let!(:user1) { create(:user) }
        let!(:auth_headers1) { { 'Authorization' => "Bearer #{user1.auth_token}" } }

        let!(:user2) { create(:user) }
        let!(:auth_headers2) { { 'Authorization' => "Bearer #{user2.auth_token}" } }

        let!(:user3) { create(:user) }
        let!(:auth_headers2) { { 'Authorization' => "Bearer #{user2.auth_token}" } }

        before { post "/follow", params: {"followed": user1.username}, headers: auth_headers }
        before { post "/follow", params: {"followed": user2.username}, headers: auth_headers }
        before { post "/follow", params: {"followed": user3.username}, headers: auth_headers }

        before { get '/follows', params: {}, headers: auth_headers}
        it "should return my own tweets" do
          payload = JSON.parse(response.body)
          expect(payload.size).to eq(3)
          expect(response).to have_http_status(200)
        end
      end
  end

end
