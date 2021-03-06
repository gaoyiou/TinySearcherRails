require 'event_loggable'

class UsersController < ApplicationController
  include EventLoggable, LoggableParams

  before_action :set_user, only: [:update, :destroy]
  after_action only: [:update] do
    log_event(@user, build_log_params(@event, @status))
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      log_event("REGISTER", "SUCCESS", @user)

      redirect_to search_index_path, notice: "You have successfully signed up."
    else
      flash.now.alert = "Sorry, sign up failed, Please try again..."
      render "new"
    end
  end

  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @event = "RESET_PASSWORD"
    @status = "SUCCESS"

    if @user.update(user_params)
      redirect_to search_index_path, notice: "Password was successfully changed."
    else
      @status ="FAILED"
      flash.now.alert = "Change Password Failed..."
      render "edit"
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
