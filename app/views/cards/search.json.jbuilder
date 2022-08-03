json.array! @search_results do |card|
  json.id card[:id]
  json.name card[:name]
end
