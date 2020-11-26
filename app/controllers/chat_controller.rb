class ChatController < ApplicationController
  include Secured
  before_action :authenticate_user!, only: [:create, :list]

  rescue_from Exception do |e|
     render json: { error: e.message }, status: :internal_server_error
  end
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: 'No se encontró ese registro' }, status: :not_found
  end


  def create
    if Current.user.authenticated == true
      sender = Current.user.id
      receiver = params[:receiver_id]
      msg = params[:message]
      if sender.present? && receiver.present? && msg.present? && sender != receiver
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
      @user_1 = Current.user.id
      @user_2 = params[:user2_id]

      if @user_1.present? && @user_2.present?
        sql = "SELECT chats.id, message, sender_id, receiver_id, chats.created_at
          FROM chats
          WHERE (sender_id=#{@user_1} AND receiver_id=#{@user_2}) OR (sender_id=#{@user_2} AND receiver_id=#{@user_1})"
        messages = ActiveRecord::Base.connection.execute(sql)
        render json: {messages: messages}, status: :ok
      else
        render json: { messages: "Invalid params" }, status: :not_acceptable
      end

    else
      render json: { message: "unauthorized" }, status: :unauthorized
    end
  end


end
