class ApplicationController < ActionController::Base
  def hello_world
    # render inline: '<em>Hello, World!</em>'
    # render "application/hello_world"
    # render inline: File.read("app/views/application/hello_world.html.erb")
    name = params["name"] || "world"
    p "p name #{name}"
    p name
    # name = "keessdfd"
    render "application/hello_world", locals: { name: name}

  end

  def list_posts


    posts = connection.execute("SELECT * FROM posts")

    render "application/list_posts", locals: {posts:posts}
  end

  def show_post

    id = params[:id]
    puts id
    post = connection.execute("SELECT * FROM posts where id==#{id}").first
    # render "application/list_posts", locals: {posts:posts}
    render "application/show_post", locals: {post: post}
  end
  
  def connection
    db_connection = SQLite3::Database.new 'db/development.sqlite3'
    db_connection.results_as_hash = true
    db_connection
  end
end
