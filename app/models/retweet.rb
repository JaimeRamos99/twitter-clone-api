class Retweet < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  validates :quote, presence: true, length: {in: 0..280}
end
