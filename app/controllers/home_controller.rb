class HomeController < ApplicationController
  before_action :require_login

  # GET /home: Home do usuário logado
  def home
  end
end
