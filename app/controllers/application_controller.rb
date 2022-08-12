class ApplicationController < ActionController::Base
  protected

  # Redireciona o usuário se ele não estiver logado (caso contrário, continua na mesma página)
  def redirect_if_logged_in
    redirect_to(home_path) if session[:user_id]
  end

  # Retorna o usuário logado
  def current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # Força o usuário a logar se não estiver logado
  def require_login
    return current_user if session[:user_id]

    redirect_to login_path
  end
end
