class Card < ApplicationRecord
  belongs_to :user

  def name
    scryfall["name"]
  end

  def image_url
    scryfall["image_uris"]["large"]
  end

  def scryfall_url
    scryfall["scryfall_uri"]
  end

  def self.scryfall_find_by_name(name)
    encoded_name = ERB::Util.url_encode(name)
    r = HTTP.get("https://api.scryfall.com/cards/named?fuzzy=#{encoded_name}")
    card = JSON.parse(r.to_s)

    card["id"]
  end

  # Loads the card from Scryfall.
  def scryfall
    return @scryfall if @scryfall.present?

    @scryfall = Rails.cache.fetch("scryfall/cards/#{scryfall_id}", expires_in: 1.day) do
      r = HTTP.get("https://api.scryfall.com/cards/#{scryfall_id}")
      JSON.parse(r.to_s)
    end

    return @scryfall
  end
end
