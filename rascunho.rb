def search_card(name)
  encoded_name = ERB::Util.url_encode(name)
  r = HTTP.get("https://api.scryfall.com/cards/named?fuzzy=#{encoded_name}")
  card = JSON.parse(r.to_s)

  card["id"]
end

def find_image(id)
  r = HTTP.get("https://api.scryfall.com/cards/#{id}")
  card = JSON.parse(r.to_s)

  card["image_uris"]["large"]
end
