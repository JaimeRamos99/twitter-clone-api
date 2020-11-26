class Comment < ApplicationRecord
  belongs_to :tweet
  belongs_to :user
  validates :content, presence: true, length: {in: 1..280}
  def as_json(options = {})
     super(options.merge({ except: [:tweet_id, :user_id, :updated_at] }))
  end
end
