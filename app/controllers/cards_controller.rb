class CardsController < ApplicationController
  before_action :require_login

  # GET /cards: lista todos os cards do usuário
  def index
    @cards = current_user.cards
  end

  # POST /cards: cria um novo card
  def create
    id = Card.scryfall_find_by_name(params[:name])

    if id.present?
      current_user.cards.create!(quantity: 1, scryfall_id: id)
    end

    redirect_to cards_path
  end

  def update
    card = current_user.cards.find(params[:id])

    quantity = card.quantity
    if params[:card][:quantity].present?
      quantity = params[:card][:quantity]
    elsif params[:card][:delta].present?
      quantity = quantity + params[:card][:delta].to_i
    end
    card.update!(quantity: quantity)

    redirect_to cards_path
  end

  # DELETE /cards/:id: deleta um card
  def destroy
    card = current_user.cards.find(params[:id])
    card.destroy

    redirect_to cards_path
  end
end

# GET    /cards: CardsController#index (lista todos os cards)
# POST   /cards: CardsController#create (cria um novo card) -- hoje em dia recebe um `params[:name]`, trocar por `params[:scryfall_id]`
# DELETE /cards/:id: CardsController#destroy (deleta um "conjuntinho de card")
# PATCH  /cards/:id: CardsController#update (atualiza um card) -- so queremos mudar a quantidade
