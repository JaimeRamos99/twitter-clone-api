require 'rails_helper'

RSpec.describe Tweet, type: :model do
  describe "asociations" do
    it { should belong_to(:user) }
  end

  describe "validations" do

    it "validates presence of required fields" do
      should validate_presence_of(:content)
    end

    it "should have enough characters" do
      should validate_length_of(:content).is_at_least(1)
    end

    it "should have at most 280 characters" do
      should validate_length_of(:content).is_at_most(280)
    end

  end
end
