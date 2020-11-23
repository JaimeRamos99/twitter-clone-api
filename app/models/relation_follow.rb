class RelationFollow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates_uniqueness_of :follower_id, scope: :followed_id
  after_create :send_email_new_follow


  def send_email_new_follow
    FollowerMailer.with(info: self).new_follower_email.deliver!
  end

end
