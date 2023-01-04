class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def hello_world
    name = params['name'] || 'world'
    render 'application/hello_world', locals: { name: name }
  end

  def list_posts
    posts = connection.execute('SELECT * FROM posts')
    # posts = Post.all
    # render 'application/list_posts', locals: { posts: posts }

    # render plain: posts
    @post_hashes = posts
    # render "application_dummy/list_posts", locals: {posts: posts}
    puts "============="
    puts @post_hashes
    render "application_dummy/list_posts"
  end

  def show_post
    # post = find_post_by_id(params[:id])
    post = Post.find(params["id"])
    # puts post
    # puts post2
    comments = connection.execute('SELECT * FROM comments WHERE comments.post_id = ?', params['id'])
    # comments = Comment.all
    # puts "================="
    # puts comments
    render 'application/show_post', locals: { post: post, comments: comments, comment: Comment.new }
  end

  def new_post
    # render "application/new_post"
    post = Post.new
    render "application/new_post", locals: { post: post }
  end

  def create_post
    post = Post.new("title" => params["title"],
                    "body" => params["body"],
                    "author" => params["author"])
    if post.save
      redirect_to '/list_posts'
    else
      render "application/new_post", locals: { post: post }
    end

    # render plain: insert_query
  end

  def edit_post
    # post = find_post_by_id(params["id"])
    post = Post.find(params["id"])
    puts post
    render "application/edit_post", locals: { post: post }
  end

  def update_post
    # render plain: "updated post"

    post = Post.find(params["id"])
    post.set_attributes('title' => params['title'],
                        'body' => params['body'],
                        'author' => params['author'])
    if post.save
      redirect_to '/list_posts'
    else
      render 'application/edit_post', locals: { post: post }
    end
  end

  def delete_post

    if %w[1 2 3].include?(params['id'])
      # render plain: "params['id'] #{params['id']} NO post deleted"
      puts "params['id'] #{params['id']} NO post deleted"
    else
      # connection.execute("DELETE FROM posts WHERE posts.id = ?", params['id'])
      post = Post.find(params['id'])
      post.destroy
    end
    redirect_to '/list_posts'
  end

  def connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end

  def find_post_by_id(id)
    post = connection.execute("SELECT * FROM posts WHERE id==?", id).first
    post
  end

  #======== comments
  def create_comment
    post = Post.find(params[:post_id])
    # post.create_comment("body" => params["body"],
    #                     "author" => params["author"],)
    comment_hash = { "body" => params["body"],
                     "author" => params["author"] }
    comment = Comment.new(comment_hash)
    comment.valid?
    if post.create_comment(comment_hash)
      redirect_to "/show_post/#{params[:post_id]}"
    else
      # puts "========= comment_temp #{comment_temp.errors}"
      render "application/show_post", locals: { post: post, comment: comment }
    end

    # render plain: "create_comment"
  end

  def delete_comment
    post = Post.find(params['post_id'])
    post.delete_comment(params['comment_id'])
    redirect_to "/show_post/#{params['post_id']}", locale: { comment_temp: Comment.new }
  end

  def destroy_comment
    comment = Comment.find(params[:id])
    # puts "==========destroy_comment comment #{comment}"
    # puts "==========destroy_comment comment #{comment.id}"
    comment.destroy
    comments = Comment.all
    render 'application/list_comments', locals: { comments: comments }
  end

  def list_comments
    comments = Comment.all
    # render plain: comments

    render 'application/list_comments', locals: { comments: comments }
  end

end
