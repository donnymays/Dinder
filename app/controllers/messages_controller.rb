class MessagesController < ApplicationController

  def index
    @messages = Recipient.where(:user_id => current_user.id).order('created_at DESC')
    
  end

  def new
    @message = Message.new
    @recipients = current_user.friends
  end

  def reply
    @recipient = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    puts params
    @message = current_user.messages.new(:sender_id => current_user.id, :body => params['message']['body'], :user_ids => params[:user_ids].map(&:to_i))
    if @message.save
      flash[:alert] = "successful message"
      redirect_to messages_path
    else
      flash[:alert] = "did not create"
      render :new
    end
  end

  def show
    @message = Message.find(params[:id])
    @sender = User.find(@message.sender_id)
    # binding.pry
  end

  def destroy
    recipient = Recipient.find(params[:recipient_id])
    recipient.destroy
    redirect_to '/messages'
  end

  private
  def message_params
    params.require(:message).permit(:body, :sender_id, user_ids: [])
  end
end