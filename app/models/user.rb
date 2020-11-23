class User < ApplicationRecord
  has_secure_password
  has_many :tweets,  dependent: :delete_all
  has_many :followers, foreign_key: "followed_id", class_name: "RelationFollow"
  has_many :following, foreign_key: "follower_id", class_name: "RelationFollow"
  validates :email, presence: true, uniqueness:true
  validates :name, presence: true
  validates :username, presence: true, uniqueness:true
  validates :password_digest, presence:true
  before_create :create_code
  after_initialize :generate_auth_token
  after_create :send_email



  def create_code
    self.emailcode = "#{Time.now.to_i.to_s(36)}#{SecureRandom.hex(8)}"
    if Rails.env.test?
      self.authenticated = true
    else
      self.authenticated = false
    end
  end


  def generate_auth_token
    unless auth_token.present?
      self.auth_token = TokenGenerationService.generate
    end
  end


  def send_email
    RegisterMailer.with(user: self).new_confirmation_email.deliver!
  end

end
