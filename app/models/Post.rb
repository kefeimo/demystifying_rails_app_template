# frozen_string_literal: true
class Post
  attr_reader :id, :title, :body, :author, :created_at, :errors

  def initialize(attributes={})
    set_attributes(attributes)

    @errors = {}
  end

  def set_attributes(attributes)
    @id = attributes['id'] if new_record?
    @title = attributes['title']
    @body = attributes['body']
    @author = attributes['author']
    @created_at ||= attributes['created_at']
  end

  def insert
    insert_query = <<-SQL
      INSERT INTO posts (title, body, author, created_at)
      VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
                       title,
                       body,
                       author,
                       Date.current.to_s
  end

  def update
    update_query  = <<-SQL
      UPDATE posts 
      SET title      = ?,
          body       = ?,
          author     = ?
      WHERE posts.id = ?
    SQL

    connection.execute update_query,
                       title,
                       body,
                       author,
                       id
  end

  def new_record?
    id.nil?
  end

  def valid?
    # title.present? && body.present? && author.present?
    @error["title"] = "Can't be blank" if title.blank?
    @errors['body']   = "can't be blank" if body.blank?
    @errors['author'] = "can't be blank" if author.blank?
    @errors.empty?
  end

  def save
    # puts "===== #{title} #{body} #{author}"
    return false unless valid?

    if new_record?
      insert
    else
      update
    end
    return true
  end

  def self.find(id)
    post_hash = connection.execute("SELECT * FROM posts WHERE posts.id = ? LIMIT 1", id).first
    post = Post.new(post_hash)
    # puts "======self.find(id)"
    # p post
    # p post
  end

  def destroy
    connection.execute "DELETE FROM posts WHERE posts.id = ?", id
  end

  def comments
    comments_hash = connection.execute("SELECT * FROM comments WHERE comments.post_id = ?", id)
    comments_hash.map do |comment_hash|
      Comment.new(comment_hash)
    end
    # puts "======self.find(id)"
    # p post
    # p post
  end

  def create_comment(attributes)
    comment = Comment.new(attributes.merge!('post_id' => id))
    comment.save
  end

  def delete_comment(comment_id)
    # puts "======== comment_id #{comment_id}"
    comment = Comment.find(comment_id)
    # puts "======== delete_comment comment #{comment}"
    # puts "======== delete_comment comment #{comment}"
    comment.destroy
  end

  def self.all
    post_hashes = connection.execute "SELECT * FROM posts"
    posts = post_hashes.map do |post_hash|
      Post.new(post_hash)
    end
    p posts
    # posts

  end

  def self.connection
    db_connection = SQLite3::Database.new('db/development.sqlite3')
    db_connection.results_as_hash = true
    db_connection
  end

  def connection
    self.class.connection
  end

end
