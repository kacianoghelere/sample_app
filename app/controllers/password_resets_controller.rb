class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def edit
    #code
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def update
    if booth_passwords_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      redirect_to @user
      flash[:success] = 'Password updated'
    else
      render 'edit'
    end
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def booth_passwords_blank?
      params[:user][:password].blank?
    end

    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        flash[:danger] = 'Invalid reset information'
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash.now[:danger] = "Password reset expired"
        redirect_to new_password_reset_url
      end
    end
end
