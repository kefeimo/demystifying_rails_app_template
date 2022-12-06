class ApplicationController < ActionController::Base
  def hello_world
    name = params['name'] || 'world'
    render 'application/hello_world', locals: { name: name }
  end

  def list_posts
    posts = connection.execute('SELECT * FROM posts')
    render 'application/list_posts', locals: { posts: posts }
  end

  def show_post
    query_string = "SELECT * FROM posts where id==#{params[:id]}"
    post = connection.execute(query_string).first
    render 'application/show_post', locals: { post: post }
  end

  def new_post
    render "application/new_post"
  end

  def create_post
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, created_at)
      VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
                       params['title'],
                       params['body'],
                       params['author'],
                       Date.current.to_s

    redirect_to '/list_posts'
    # render plain: insert_query
  end

  def connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end
end
