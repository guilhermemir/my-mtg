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
    @results = []
    if params[:name].present? && params[:name].length > 5
      @results = Card.scryfall_find_all_by_name(params[:name])
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update("results", partial: "search", locals: { query: params[:name], results: @results }),
        ]
      end
    end
  end

  # POST /cards: cria um novo card
  def create
    id = params[:scryfall_id]
    card = current_user.cards.create!(quantity: 1, scryfall_id: id)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.prepend("cards", card),
        ]
      end
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
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(card),
        ]
      end
    end
  end

  # DELETE /cards/:id: deleta um card
  def destroy
    card = current_user.cards.find(params[:id])
    card.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(card),
        ]
      end
    end
  end
end
