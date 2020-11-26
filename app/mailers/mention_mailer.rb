class MentionMailer < ApplicationMailer
  def new_mention_email
    @mentioned_user = params[:mentioned_user]
    @mentioned_email = @mentioned_user.email
    @mentioned_username = @mentioned_user.username
    @mentioner = params[:mentioner]
    mail to: @mentioned_email, subject: 'New Mention'
  end
end
