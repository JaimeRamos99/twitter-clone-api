class Tweet < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: {in: 1..280}
  def as_json(options = {})
     super(options.merge({ except: [:user_id, :updated_at] }))
  end
end
