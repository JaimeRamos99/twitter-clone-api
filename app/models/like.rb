class Like < ApplicationRecord
  belongs_to :tweet
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :tweet_id
end
