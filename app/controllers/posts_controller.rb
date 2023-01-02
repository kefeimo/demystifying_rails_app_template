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
    # binding.pry
    @post = Post.new(user_params)
    if @post.save
      flash[:success] = "You have successfully created the post."
      puts "========= flash #{flash}"
      redirect_to '/posts'
    else
      flash.now[:error] = "Post couldn't be created. Please check the errors."
      p "========= flash #{flash.now}"
      p "========= flash #{flash.now[:error]}"
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
    render "edit"
    # render plain: "edit place holder"
  end

  def update
    @post = Post.new(user_params)
    if @post.save
      redirect_to '/posts'
    else
      render "edit"
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

  def create_comment
    @post = Post.find(params[:post_id])
    # post.create_comment("body" => params["body"],
    #                     "author" => params["author"],)
    comment_hash = {"body" => params["body"],
                    "author" => params["author"]}
    # comment_hash = params[:comment]
    @comment = Comment.new(comment_hash)
    if @comment.create(comment_hash)
      render 'show', locals: { post: @post , comment: @comment}
    else
      # puts "========= comment_temp #{comment_temp.errors}"
      render "show", locals: { post: @post , comment: @comment}
    end
  end

  def delete_comment
    @post = Post.find(params["post_id"])
    @post.delete_comment(params['comment_id'])
    @comments = @post.comments
    @comment = Comment.new
    render "show"
  end

  private

  def user_params
    params.require(:post).permit(:title, :author, :body)
  end

end