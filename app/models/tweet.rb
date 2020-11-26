class Tweet < ApplicationRecord
  belongs_to :user
  has_many :likes
  has_many :comments, dependent: :delete_all
  validates :content, presence: true, length: {in: 1..280}
  def as_json(options = {})
     super(options.merge({ except: [:user_id, :updated_at] }))
  end
end
