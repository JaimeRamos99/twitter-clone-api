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
      puts "----------------"
      puts tweet
      puts cmmnt
      puts user_idd
      puts "----------------"
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
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end
end
