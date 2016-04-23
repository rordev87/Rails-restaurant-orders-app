json.array!(@items) do |item|
  json.extract! item, :id, :name, :user_id, :order_id, :quantity, :price, :comment
  json.url item_url(item, format: :json)
end
