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

  # Returns the *first* card in Scryfall with given name.
  def self.scryfall_find_by_name(name)
    encoded_name = ERB::Util.url_encode(name)
    r = HTTP.get("https://api.scryfall.com/cards/named?fuzzy=#{encoded_name}")
    card = JSON.parse(r.to_s)

    card["id"]
  end

  # Returns a *list of all* cards in Scryfall with given name.
  def self.scryfall_find_all_by_name(name)
    encoded_name = ERB::Util.url_encode(name)
    r = HTTP.get("https://api.scryfall.com/cards/search?unique=prints&order=released&q=#{encoded_name}")
    search_result = JSON.parse(r.to_s)

    search_result["data"].map do |c|
      {
        id: c["id"],
        name: "#{c["name"]} (#{c["set_name"]}, ##{c["collector_number"]})",
      }
    end
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
