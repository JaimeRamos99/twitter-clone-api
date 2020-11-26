class LikeController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:create, :destroy, :count, :list]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: 'No se encontró ese registro' }, status: :not_found
  end

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

  def count
    if Current.user.authenticated == true
      twt_id = params[:tweet_id]
      @tuit = Tweet.find(twt_id)
      if @tuit.present?
          sql = "SELECT COUNT(*)
            FROM likes
            WHERE tweet_id=#{@tuit.id}"
          likes_counter = ActiveRecord::Base.connection.execute(sql)

        render json: likes_counter[0] , status: :ok
      else
        render json: { message: "there is not tweet with that ID" }, status: :not_acceptable
      end
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end

  def list
    if Current.user.authenticated == true
      twt_id = params[:tweet_id]
      @tuit = Tweet.find(twt_id)
      if @tuit.present?
          sql = "SELECT users.username
            FROM likes
            JOIN users ON likes.user_id = users.id
            WHERE tweet_id=#{@tuit.id}"
          likers = ActiveRecord::Base.connection.execute(sql)
          render json: likers , status: :ok
      else
          render json: { message: "there is not tweet with that ID" }, status: :not_acceptable
      end
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end

end
