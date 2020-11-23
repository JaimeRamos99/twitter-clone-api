require 'rails_helper'

RSpec.describe "Relationfollows", type: :request do

  describe "post /follow (follow a user)" do

    context "valid follow" do

      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
      let!(:other_user) { create(:user) }
      before { post "/follow", params: {"followed": other_user.username}, headers: auth_headers }

      context "payload" do
          subject { JSON.parse(response.body) }
          it { is_expected.to eq({"followed"=>true})}
      end

      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:ok) }
      end

    end

    context "invalid follow, no specified user to follow" do
      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
      before { post "/follow", params: {}, headers: auth_headers }
      context "payload" do
          subject { JSON.parse(response.body) }
          it { is_expected.to eq("error"=>"no user to follow")}
      end

      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:not_found) }
      end

    end

    context "invalid follow, wrong user" do
      let!(:user) { create(:user) }
      let!(:auth_headers) { { 'Authorization' => "Bearer #{user.auth_token}" } }
      before { post "/follow", params: {"followed": Faker::Name.name}, headers: auth_headers }
      context "payload" do
          subject { JSON.parse(response.body) }
          it { is_expected.to eq("error"=>"no user to follow")}
      end

      context "response" do
        subject { response }
        it { is_expected.to have_http_status(:not_found) }
      end

    end

  end

end
