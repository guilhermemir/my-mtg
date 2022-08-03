class CardsController < ApplicationController
  before_action :require_login

  skip_before_action :verify_authenticity_token

  # GET /cards: lista todos os cards do usuário
  def index
    @cards = current_user.cards.order(created_at: :desc)

    respond_to do |format|
      format.html # app/views/cards/index.html.erb
      format.json # app/views/cards/index.json.jbuilder
    end
  end

  def search
    @search_results = Card.scryfall_find_all_by_name(params[:name])

    respond_to do |format|
      format.html do
        index
        render template: "cards/index"
      end
      format.json # app/views/cards/search.json.jbuilder
    end
  end

  # POST /cards: cria um novo card
  def create
    id = params[:scryfall_id]

    if id.present?
      current_user.cards.create!(quantity: 1, scryfall_id: id)
    end

    respond_to do |format|
      format.html { redirect_to cards_path }
      format.json { render json: { status: "ok" } }
    end
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

    respond_to do |format|
      format.html { redirect_to cards_path }
      format.json { render json: { status: "ok" } }
    end
  end

  # DELETE /cards/:id: deleta um card
  def destroy
    card = current_user.cards.find(params[:id])
    card.destroy

    respond_to do |format|
      format.html { redirect_to cards_path }
      format.json { render json: { status: "ok" } }
    end
  end
end

# GET    /cards: CardsController#index (lista todos os cards)
# POST   /cards: CardsController#create (cria um novo card) -- hoje em dia recebe um `params[:name]`, trocar por `params[:scryfall_id]`
# DELETE /cards/:id: CardsController#destroy (deleta um "conjuntinho de card")
# PATCH  /cards/:id: CardsController#update (atualiza um card) -- so queremos mudar a quantidade
