json.data do
  json.array! @posts, :id, :title, :content, :author_id
end
