class IndexController < ApplicationController
  before_action :redirect_if_logged_in, only: [:index]

  def index
  end

  def contact
  end
end
