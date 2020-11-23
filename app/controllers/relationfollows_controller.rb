class RelationfollowsController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    followed_user = User.find_by(username: params[:followed])
    if followed_user.present?
      if Current.user.id != followed_user.id && Current.user.authenticated
        @rel = RelationFollow.create!(follower_id: Current.user.id,
                                      followed_id: followed_user.id
                                     )
        render json: { followed: true }, status: :ok
      else
        render json: { error: "unauthorized"}, status: :unauthorized
      end
    else
      render json: { error: "no user to follow"}, status: :not_found
    end
  end


  def destroy
    followed_user = User.find_by(username: params[:followed_username])
    if followed_user.present? && Current.user.authenticated
      relation = RelationFollow.find_by(follower_id: Current.user.id, followed_id: followed_user.id)
      if relation.present? && relation.follower_id == Current.user.id
        relation.destroy
        render json: { unfollowed: true }, status: :accepted
      else
        render json: { error: 'unauthorized'}, status: :unauthorized
      end
    else
      render json: { error: 'unauthorized'}, status: :unauthorized
    end
  end


end
