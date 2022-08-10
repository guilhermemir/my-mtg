class Card < ApplicationRecord
  belongs_to :user

  def name
    scryfall["name"]
  end

  def image_url
    scryfall.dig("image_uris", "large").presence ||
      scryfall.dig("image_uris", "normal").presence ||
      scryfall.dig("image_uris", "small").presence ||
      scryfall.dig("card_faces", 0, "image_uris", "large").presence ||
      scryfall.dig("card_faces", 0, "image_uris", "normal").presence ||
      scryfall.dig("card_faces", 0, "image_uris", "small").presence ||
      "https://via.placeholder.com/672x936"
  end

  # Returns the web URL for the card (to visit in the browser).
  def scryfall_url
    scryfall["scryfall_uri"]
  end

  # Returns the API URL for the card (JSON).
  def scryfall_api_url
    "https://api.scryfall.com/cards/#{scryfall_id}"
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

    search_result = Rails.cache.fetch("scryfall/search/#{Base64.encode64(encoded_name).chomp}", expires_in: 1.day) do
      Rails.logger.info "Calling Scryfall API: search for #{encoded_name}"
      r = HTTP.get("https://api.scryfall.com/cards/search?include_multilingual=false&unique=prints&include_extras=true&include_variations=false&pretty=false&dir=asc&order=released&q=#{encoded_name}")
      JSON.parse(r.to_s)
    end

    cards = search_result["data"].
      # select { |c| (c["printed_name"].presence || c["name"]).to_s.match(name) }.
      map do |c|
      card_name = c["printed_name"].presence || c["name"]

      {
        id: c["id"],
        name: "#{card_name} (#{c["set_name"]}, ##{c["collector_number"]})",
      }
    end
  end

  # Loads the card from Scryfall.
  def scryfall
    return @scryfall if @scryfall.present?

    @scryfall = Rails.cache.fetch("scryfall/cards/#{scryfall_id}", expires_in: 1.day) do
      Rails.logger.info "Calling Scryfall API: card for #{scryfall_id}"
      r = HTTP.get(scryfall_api_url)
      JSON.parse(r.to_s)
    end

    return @scryfall
  end
end
