class User < ApplicationRecord
  has_secure_password
  has_many :tweets, dependent: :delete_all
  has_many :followers, foreign_key: "followed_id", class_name: "RelationFollow",  dependent: :delete_all
  has_many :following, foreign_key: "follower_id", class_name: "RelationFollow",  dependent: :delete_all
  has_many :likes, dependent: :delete_all
  validates :email, presence: true, uniqueness:true
  validates :name, presence: true
  validates :username, presence: true, uniqueness:true
  validates :password_digest, presence:true
  before_create :create_code
  after_initialize :generate_auth_token

  if Rails.env.production?
    after_create :send_email
  end


  def create_code
    self.emailcode = "#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
    if Rails.env.production?
      self.authenticated = false
    else
      self.authenticated = true
    end
  end


  def generate_auth_token
    unless auth_token.present?
      self.auth_token = TokenGenerationService.generate
    end
  end


  def send_email
    RegisterMailer.with(user: self).new_confirmation_email.deliver_later!
  end

end
