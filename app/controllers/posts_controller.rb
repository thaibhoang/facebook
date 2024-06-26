class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    good_ids = allowed_user_ids
    @posts = Post.where('updated_at > ?', Time.now - 7.days).where(user_id: good_ids).order(updated_at: :desc)
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @like = current_user.likes.find_by(post_id: @post.id)
    @like_count = @post.likes.count
    @comments = @post.comments
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      if @post.update(post_params)
        redirect_to @post
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.user_id == current_user.id
      @post.destroy
      redirect_to posts_path
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :title, :body, :img_url, :rich_body, :images => [])
  end

  def allowed_user_ids
    acceptedRequests = FollowRequest.where(accepted: true, sender_id: current_user.id)
    allowed_user_ids = acceptedRequests.pluck(:receiver_id)
    allowed_user_ids << current_user.id
  end
end
