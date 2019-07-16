class Api::V1::PostsController < ApiController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    return render json: { errors: @post.errors.full_messages }, status: 422 unless @post.save
    render 'show', status: 201
  end

  def update
    @post = Post.find(params[:id])
    return render json: { errors: @post.errors.full_messages }, status: 422 unless @post.update(post_params)
    render 'show'
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    head 204
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :author_id)
  end
end
