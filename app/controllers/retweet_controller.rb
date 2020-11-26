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
      @quote = params[:quote]
      if @tweet_id.present?
        the_tweet = Tweet.find(@tweet_id)
        if the_tweet.present?
          valid = Retweet.create(tweet_id: @tweet_id, user_id: Current.use.id).valid?
        else
        end
      else
        render json: {message: "no tweet id found"}, status: :not_acceptable
      end
    else
    end
  end

  def count

  end

end
