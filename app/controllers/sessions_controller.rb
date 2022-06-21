class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]

  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && params[:password] == "a"
      session[:user_id] = user.id
      redirect_to home_path, notice: "Bem-vindo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Você saiu."
  end
end
