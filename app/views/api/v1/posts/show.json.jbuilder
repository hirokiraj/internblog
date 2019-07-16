json.data do
  json.call(@post, :id, :title)
  json.author do
    json.call(@post.author, :name, :surname)
  end
end
