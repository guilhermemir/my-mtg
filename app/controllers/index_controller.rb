class IndexController < ApplicationController
  before_action :redirect_if_logged_in, only: [:index]

  # GET /: página inicial com usuário não logado
  def index
  end

  # GET /contact: página de contato
  def contact
  end
end
