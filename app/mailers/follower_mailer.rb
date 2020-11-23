class FollowerMailer < ApplicationMailer
  def new_follower_email
    @info = params[:info]
    @user_followed = User.find(@info.followed_id)
    @user_follower = User.find(@info.follower_id)
    @url = 'https://my-twitter.surge.sh/profile/' + @user_follower.username
    puts @user_followed.email
    mail to: @user_followed.email, subject: 'New Follower'
  end
end
