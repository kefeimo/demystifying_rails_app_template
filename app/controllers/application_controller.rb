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
    post = find_post_by_id(params["id"])
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

  def edit_post
    post = find_post_by_id(params["id"])
    puts post
    render "application/edit_post", locals:{post:post}
  end

  def update_post
    # render plain: "updated post"
    update_query = <<-SQL
          UPDATE posts
          SET title      = ?,
              body       = ?,
              author     = ?
          WHERE posts.id = ?
        SQL
        connection.execute update_query, params['title'], params['body'], params['author'], params['id']

        redirect_to '/list_posts'
  end

  def delete_post

    if %w[1 2 3].include?(params['id'])
      # render plain: "params['id'] #{params['id']} NO post deleted"
      puts "params['id'] #{params['id']} NO post deleted"
    else
      connection.execute("DELETE FROM posts WHERE posts.id = ?", params['id'])
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
end
