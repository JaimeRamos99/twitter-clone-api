class TweetController < ApplicationController

  include Secured
  before_action :authenticate_user!, only: [:create, :destroy, :list, :list_own, :user_info]


  rescue_from Exception do |e|
     render json: { error: e.message }, status: :internal_server_error
  end


  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end


  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end


  def create
    if Current.user.authenticated == true
      @tweet = Current.user.tweets.create!(create_params)
      render json: @tweet, status: :created
    else
      render json: { created: false }, status: :not_found
    end
  end

  def list
    if Current.user.authenticated == true
      sql = "SELECT users.username, users.name, tweets.id, content, tweets.created_at
       FROM tweets
       JOIN relation_follows ON tweets.user_id = relation_follows.followed_id
       JOIN users ON tweets.user_id = users.id
       WHERE relation_follows.follower_id=#{Current.user.id}
       UNION
       SELECT users.username, users.name,tweets.id, content, tweets.created_at
       FROM tweets
       JOIN users ON tweets.user_id = users.id
       WHERE tweets.user_id =#{Current.user.id}"
       @records_array = ActiveRecord::Base.connection.execute(sql)
       render json: {tweets: @records_array}, status: :ok
   else
     render json: { message: "unauthorized" }, status: :unauthorized
   end
  end


  def destroy
    if Current.user.authenticated == true &&
      @tweet = Current.user.tweets.find(params[:id])
      if @tweet.present?
        Current.user.tweets.destroy(params[:id])
        render json: { destroyed: true }, status: :ok
      else
        render json: { destroyed: false }, status: :not_found
      end
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  private

  def create_params
    if Rails.env.test?
      params.permit(:content)
    else
      params.require(:tweet).permit(:content)
    end
  end

end
