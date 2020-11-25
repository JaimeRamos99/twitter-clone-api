class LikeController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:create, :destroy]

  def create

    tweet_id = params[:tweet_id]
    @tuit = Tweet.find(tweet_id)
    if Current.user.authenticated == true && @tuit.present?
      valid = Like.create(user_id: Current.user.id, tweet_id: @tuit.id).valid?
      if valid
        render json: {liked: true}, status: :ok
      else
        render json: {liked: false}, status: :ok
      end

    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end

  end


  def destroy

    tweet_id = params[:tweet_id]
    @tuit = Tweet.find(tweet_id)
    if Current.user.authenticated == true && @tuit.present?
      like = Like.find_by(user_id: Current.user.id, tweet_id: @tuit.id)
      if like.present?
        like.destroy!
        if like.destroyed?
          render json: { unliked: true }, status: :accepted
        else
          render json: { unliked: false }, status: :accepted
        end
      else
        render json: { unliked: false }, status: :accepted
      end
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end

  end

end
