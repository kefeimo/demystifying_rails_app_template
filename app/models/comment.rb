# frozen_string_literal: true

class Comment
  attr_reader :id, :title, :body, :author, :created_at

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
