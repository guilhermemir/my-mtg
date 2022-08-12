class SessionsController < ApplicationController
  before_action :redirect_if_logged_in, only: [:new]

  # GET /session: Formulário de login
  def new
  end

  # POST /session: Autentica o usuário, redireciona para a página inicial (home)
  def create
    user = User.find_by(email: params[:email])

    if user && user.password == params[:password]
      session[:user_id] = user.id
      redirect_to home_path, notice: "Bem-vindo."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /session: Destrói a sessão do usuário (desloga)
  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Você saiu."
  end
end
