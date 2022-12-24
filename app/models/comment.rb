# frozen_string_literal: true

class Comment
  attr_reader :id, :title, :body, :author, :post_id, :created_at

  def initialize(attributes={})
    set_attributes(attributes)

    @errors = {}
  end

  def new_record?
    id.nil?
  end

  def set_attributes(attributes)
    # puts "==============="
    # puts attributes
    # puts "new_record? #{new_record?}, attributes['id'] #{attributes['id']}"
    @id = attributes['id'] if new_record?
    @title = attributes['title']
    @body = attributes['body']
    @author = attributes['author']
    @post_id = attributes['post_id']
    @created_at ||= attributes['created_at']
  end

  def save
    # puts "===== #{title} #{body} #{author}"
    # return false unless valid?

    if new_record?
      insert
    else
      update
    end
    return true
  end

  def insert
    insert_query = <<-SQL
      INSERT INTO comments (body, author, created_at, post_id)
      VALUES (?, ?, ?, ?)
    SQL

    connection.execute insert_query,
                       body,
                       author,
                       Date.current.to_s,
                       post_id
  end

  def update
    # update_query  = <<-SQL
    #   UPDATE comments
    #   SET
    #       body       = ?,
    #       author     = ?
    #   WHERE l.id = ?
    # SQL
    #
    # connection.execute update_query,
    #
    #                    body,
    #                    author,
    #                    id
  end

  def self.find(id)
    comment_hash = connection.execute("SELECT * FROM comments WHERE comments.id = ? LIMIT 1", id).first
    comment = Comment.new(comment_hash)
    # puts "======self.find(id)"
    # p post
    # p post
  end

  def self.all
    comment_hashes = connection.execute "SELECT * FROM comments"
    comments = comment_hashes.map do |comment_hash|
      Post.new(comment_hash)
    end
    # p posts
    # posts
    comments

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
