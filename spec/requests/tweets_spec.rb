require "rails_helper"
RSpec.describe "Tweets", type: :request do

    describe "GET /tweets without a valid authorization token" do
      before { get '/tweets'}
      it "should return OK" do
        payload = JSON.parse(response.body)
        expect(payload).to eq({"error"=>"unauthorized"})
        expect(response).to have_http_status(401)
      end
    end

    describe "GET /tweets with a valid authorization token " do

      context "User without tweets" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        before { get '/tweets', params: {}, headers: auth_headers}
        it "should return OK" do
          payload = JSON.parse(response.body)
          expect(payload["tweets"]).to be_empty
          expect(response).to have_http_status(200)
        end
      end

      context "User with tweets" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        let!(:tweets) { create_list(:tweet, 10, user: user) }
        before { get '/own_tweets', params: {}, headers: auth_headers}
        it "should return my own tweets" do
          payload = JSON.parse(response.body)
          expect(payload["my_tweets"].size).to eq(tweets.size)
          expect(response).to have_http_status(200)
        end
      end

    end

    describe "POST /tweets" do

      context "Valid tweet" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        let!(:user_tweet) { create(:tweet, user: user) }
        before { post "/tweet", params: {"content": user_tweet.content}, headers: auth_headers }

        context "payload" do
          subject { JSON.parse(response.body) }
          it { is_expected.to include("id", "content", "created_at", "author") }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:created) }
        end

      end

      context "Invalid tweet" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        before { post "/tweet", params: {}, headers: auth_headers }

        context "payload" do
          subject { JSON.parse(response.body) }
          it { is_expected.to eq({"error"=>"Validation failed: Content can't be blank, Content is too short (minimum is 1 character)"}) }
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:unprocessable_entity) }
        end
      end

    end

    describe "DELETE /tweets" do

      context "valid deletion" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        let!(:user_tweet) { create(:tweet, user: user) }
        before { delete "/tweet", params: {"id": user_tweet.id}, headers: auth_headers }

        context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to eq({"destroyed"=>true})}
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:ok) }
        end

      end

      context "invalid deletion, no tweet id" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
        let!(:user_tweet) { create(:tweet, user: user) }
        before { delete "/tweet", params: {}, headers: auth_headers }

        context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to eq({"error"=>"Couldn't find Tweet without an ID"})}
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:not_found) }
        end

      end

      context "invalid deletion, not a tweet from the user requesting the deletion" do
        let!(:user) { create(:user) }
        let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }

        let!(:other_user) { create(:user) }
        let!(:other_user_auth_headers) { { 'Authorization' => "Bearer #{other_user.auth_token}" } }

        let!(:user_tweet) { create(:tweet, user: user) }

        before { delete "/tweet", params: {"id": user_tweet.id}, headers: other_user_auth_headers }

        context "payload" do
            subject { JSON.parse(response.body) }
            it { is_expected.to include("error")}
        end

        context "response" do
          subject { response }
          it { is_expected.to have_http_status(:not_found) }
        end

      end

    end

end
