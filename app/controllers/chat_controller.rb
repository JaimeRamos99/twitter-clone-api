class ChatController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:create, :list]

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: 'No se encontró ese registro' }, status: :not_found
  end


  def create
    if Current.user.authenticated == true
      sender = Current.user.id
      receiver = params[:receiver_id]
      msg = params[:message]
      if sender.present? && receiver.present? && msg.present?
        valid = Chat.create!(sender_id: sender, receiver_id: receiver, message: msg).valid?
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
      user_1 = Current.user.id
      user_2 = params[:user2_id]
    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end


end
