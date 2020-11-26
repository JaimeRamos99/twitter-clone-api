class UserController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:followers, :follows, :profile]

  rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {error: e.message}, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: 'No se encontró ese registro' }, status: :not_found
  end

  def create
    @user = User.create!(create_user_params)
    if @user.present?
      render json: {created: true}, status: :internal_server_error
    else
      render json: {created: false}, status: :created
    end
  end


  def confirmation
    @user = User.find_by(username: params[:user])
    if (@user.present? && (@user.emailcode == params[:emailcode]) && @user.authenticated == false)
      @user.update_attribute(:authenticated, true)
      render json: {updated: true}, status: :ok
    else
      render json: {updated: false}, status: :not_found
    end
  end


  def login
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password]) && @user.authenticated == true
      render json: {logged: true, auth_token: @user.auth_token, username: @user.username, name: @user.name}, status: :ok
    else
      render json: {logged: false}, status: :unauthorized
    end
  end


  def destroy
    @user = User.find_by(username: params[:username])
    if @user.present? && @user.authenticate(params[:password])
      @user.destroy
      render json: { deleted: true }, status: :accepted
    else
      render json: { deleted: false}, status: :unauthorized
    end
  end


  def followers
    if Current.user.authenticated == true
      @user = User.find_by(username: params[:username])
      if @user.present?
        sql = "SELECT users.id, username, name
         FROM users
         JOIN relation_follows ON users.id = relation_follows.follower_id
         WHERE followed_id=#{@user.id}"
        records_array = ActiveRecord::Base.connection.execute(sql)
        render json: {followers: records_array}
      else
        render json: {message: "credentials not found"}, status: :unauthorized
      end
    else
      render json: {message: "unauthorized"}, status: :unauthorized
    end
  end

  def follows
    if Current.user.authenticated == true
      @user = User.find_by(username: params[:username])
      if @user.present?
        sql = "SELECT username, name
          FROM users
          JOIN relation_follows ON users.id = relation_follows.followed_id
          WHERE follower_id=#{@user.id}"
        records_array = ActiveRecord::Base.connection.execute(sql)
        render json: {following: records_array}
      else
        render json: {message: "credentials not found"}, status: :unauthorized
      end
    else
      render json: {message: "unauthorized"}, status: :unauthorized
    end
  end

  def profile
    if Current.user.authenticated == true
      @user = User.find_by(username: params[:username])
      render json: @user, current_user: Current.user.id, status: :ok
    end
  end

  private
  def create_user_params
    params.permit(:username, :email, :name, :password)
  end

  def follow_params
    params.permit(:follower, :followed)
  end
end
