class CardsController < ApplicationController
  before_action :require_login

  def index
    @cards = current_user.cards
  end

  def create
    id = Card.scryfall_find_by_name(params[:name])

    if id.present?
      current_user.cards.create!(quantity: 1, scryfall_id: id)
    end

    redirect_to cards_path
  end
end
