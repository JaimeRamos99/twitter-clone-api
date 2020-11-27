class RetweetController < ApplicationController

  include Secured
  before_action :authenticate_user!, only: [:create, :count]


  rescue_from Exception do |e|
     render json: { error: e.message }, status: :internal_server_error
  end


  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end


  def create
    if Current.user.authenticated == true
      @tweet_id = params[:tweet_id]
      @quote = params[:quote] || "nulo"
      if @tweet_id.present?
        the_tweet = Tweet.find(@tweet_id)
        if the_tweet.present?
          valid = Retweet.create(tweet_id: @tweet_id, user_id: Current.user.id, quote: @quote).valid?
          render json: { created: valid}, status: :ok
        else
          render json: { created: false}, status: :ok
        end
      else
        render json: {message: "no tweet id found"}, status: :not_acceptable
      end
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

  def count
    if Current.user.authenticated == true
      @tweet_id = params[:tweet_id]
      if @tweet_id.present?
        the_tweet = Tweet.find(@tweet_id)
        if the_tweet.present?
          sql = "SELECT COUNT(*)
            FROM retweets
            WHERE tweet_id =#{@tweet_id}"
          matches = ActiveRecord::Base.connection.execute(sql)
          render json: matches[0], status: :ok
        else
          render json: { error: "not tweet found"}, status: :ok
        end
      else
        render json: { error: "not tweet found"}, status: :ok
      end
    else
      render json: { error: "unauthorized" }, status: :unauthorized
    end
  end

end
