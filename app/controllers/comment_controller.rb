class CommentController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:create, :list]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: 'No se encontró ese registro' }, status: :not_found
  end

  def create
    if Current.user.authenticated == true
      tweet = params[:tweet_id]
      cmmnt = params[:comment]
      user_idd = Current.user.id
      if tweet.present? && cmmnt.present? && user_idd.present?
        valid = Comment.create!(tweet_id: tweet, user_id: user_idd, content: cmmnt).valid?
        render json: { created: valid }, status: :ok
      else
        render json: { created: false }, status: :ok
      end
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end

  def list
    if Current.user.authenticated == true
      tweet = params[:tweet_id]
      if tweet.present?
        @the_tweet = Tweet.find(tweet)
        if @the_tweet.present?
          sql = "SELECT username, comments.content, comments.created_at
            FROM comments
            JOIN users ON users.id = comments.user_id
            WHERE tweet_id =#{tweet}"
          matches = ActiveRecord::Base.connection.execute(sql)
          render json: matches, status: :ok
        else
          render json: { message: "tweet not found" }, status: :not_acceptable
        end
      else
        render json: { message: "tweet not found" }, status: :not_acceptable
      end
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end
end
