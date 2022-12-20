class ApplicationController < ActionController::Base
  def hello_world
    name = params['name'] || 'world'
    render 'application/hello_world', locals: { name: name }
  end

  def list_posts
    # posts = connection.execute('SELECT * FROM posts')
    posts = Post.all
    render 'application/list_posts', locals: { posts: posts }
  end

  def show_post
    # post = find_post_by_id(params[:id])
    post = Post.find(params["id"])
    # puts post
    # puts post2
    render 'application/show_post', locals: { post: post }
  end

  def new_post
    # render "application/new_post"
    post = Post.new
    render "application/new_post", locals: {post: post}
  end

  def create_post
    post = Post.new("title" => params["title"],
                    "body" => params["body"],
                    "author" => params["author"])
    if post.save
      redirect_to '/list_posts'
    else
      render "application/new_post", locals: {post:post}
    end


    # render plain: insert_query
  end

  def edit_post
    # post = find_post_by_id(params["id"])
    post = Post.find(params["id"])
    puts post
    render "application/edit_post", locals:{post:post}
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

  def route
    puts "========"
    render plain: "route test id= #{params[:id]}"
  end

end
