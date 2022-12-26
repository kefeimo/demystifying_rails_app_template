class PostsController < ActionController::Base
  def index
    @posts = Post.all
    render 'index'
    # render plain: "index"
  end

  def show
    @post = Post.find(params["id"])
    @comments = @post.comments
    @comment = Comment.new
    render 'show'
  end

  def new
    @post = Post.new
    render "new"
    # render plain: "post new"
  end

  def create
    @post = Post.new("title" => params["title"],
                    "body" => params["body"],
                    "author" => params["author"])
    if @post.save
      redirect_to '/posts'
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
    render "edit"
    # render plain: "edit place holder"
  end

  def update
    @post = Post.new("title" => params["title"],
                     "body" => params["body"],
                     "author" => params["author"])
    if @post.save
      redirect_to '/posts'
    else
      render "new"
    end
    # render plain: "update place-holder"
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to "/posts"
    # render "index"
    # render plain: "destroy place-holder"
  end

end