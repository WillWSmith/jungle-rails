class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user = User.authenticate_with_credentials(params[:email], params[:password])
      session[:user_id] = user.id
      flash[:notice] = 'Logged in successfully!'
      redirect_to root_path
    else
      flash.now[:alert] = 'Invalid email or password'
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Logged out successfully!'
    redirect_to root_path
  end
end
