class RegisterMailer < ApplicationMailer
  def new_confirmation_email
    @user = params[:user]
    @url = 'https://ruby-twitter-api-2.herokuapp.com/user_confirm_register?user='+@user.username+'&emailcode=' + @user.emailcode
    mail to: @user.email, subject: 'Confirm register to Twitta'
  end
end
