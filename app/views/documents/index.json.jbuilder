json.array!(@documents) do |document|
  json.extract! document, :id, :index
  json.url document_url(document, format: :json)
end
