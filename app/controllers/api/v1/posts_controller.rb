class Api::V1::PostsController < ApiController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(post_params)
    return render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity unless @post.save

    render 'show', status: :created
  end

  def update
    @post = Post.find(params[:id])
    unless @post.update(post_params)
      return render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end

    render 'show'
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :author_id)
  end
end
