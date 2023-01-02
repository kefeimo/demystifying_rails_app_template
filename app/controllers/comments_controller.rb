class CommentsController < ActionController::Base
  def index
    @comments = Comment.all
    render 'index'
    # render plain: "index"
  end

  # def show
  #   @comment = Comment.find(params["id"])
  #   @comments = @post.comments
  #   @comment = Comment.new
  #   render 'show'
  # end

  # def new
  #   @post = Post.new
  #   render "new"
  #   # render plain: "post new"
  # end

  def create
    # binding.pry
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(user_params) # TODO: understand the magic logics
    # puts "======== CommentsController#create @comment #{@comment}, #{@comment.id}, #{@comment.post_id}"
    redirect_to post_path(@post.id)
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
    puts "===destroy params #{params}"
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@comment.post_id)
    # render "index"
    # render plain: "destroy place-holder"
  end

  # def create_comment
  #   @post = Post.find(params[:post_id])
  #   # post.create_comment("body" => params["body"],
  #   #                     "author" => params["author"],)
  #   comment_hash = {"body" => params["body"],
  #                   "author" => params["author"]}
  #   @comment = Comment.new(comment_hash)
  #   if @post.create_comment(comment_hash)
  #     render 'show', locals: { post: @post , comment: @comment}
  #   else
  #     # puts "========= comment_temp #{comment_temp.errors}"
  #     render "show", locals: { post: @post , comment: @comment}
  #   end
  # end

  def delete_comment
    @post = Post.find(params["post_id"])
    @post.delete_comment(params['comment_id'])
    @comments = @post.comments
    @comment = Comment.new
    render "show"
  end

  private

  def user_params
    params.require(:comment).permit(:author, :body)
  end

end