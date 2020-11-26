class Retweet < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  validates :quote, presence: true, length: {in: 0..280}
  validates_uniqueness_of :user_id, scope: :tweet_id
end
