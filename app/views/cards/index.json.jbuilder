json.array! @cards do |card|
  json.id card.id
  json.name card.name
  json.quantity card.quantity
end
