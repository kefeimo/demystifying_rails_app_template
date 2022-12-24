# frozen_string_literal: true

class Comment < BaseModel
  attr_reader :id, :title, :body, :author, :post_id, :created_at, :errors

  def initialize(attributes={})
    set_attributes(attributes)

    @errors = {}
  end

  # def new_record?
  #   id.nil?
  # end

  def valid?
    @errors['body']   = "can't be less than 3" if body.length < 3
    @errors['author'] = "can't be less than 3" if author.length < 3
    @errors.empty?
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

  # def save
  #   return false unless valid?
  #
  #   if new_record?
  #     insert
  #   else
  #     update
  #   end
  #   return true
  # end

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

  # def self.find(id)
  #   comment_hash = connection.execute("SELECT * FROM comments WHERE comments.id = ? LIMIT 1", id).first
  #   # puts "========== self.find comment_hash #{comment_hash}"
  #   comment = Comment.new(comment_hash)
  #   # puts "========== self.find comment #{comment}"
  #   comment
  #   # puts "======self.find(id)"
  #   # p post
  #   # p post
  # end

  # def destroy
  #   connection.execute "DELETE FROM comments WHERE id = ?", id
  # end

  # def self.all
  #   comment_row_hashes = connection.execute("SELECT * FROM comments")
  #   # puts "=========== comment_row_hashes #{comment_row_hashes}"
  #   comments = comment_row_hashes.map do |comment_row_hash|
  #     Comment.new(comment_row_hash)
  #   end
  #   puts "======== self.all comments #{comments}"
  #   comments
  # end

  def post
    Post.find(post_id) # This can be accomplished using an existing method
  end

  # def self.connection
  #   db_connection = SQLite3::Database.new('db/development.sqlite3')
  #   db_connection.results_as_hash = true
  #   db_connection
  # end
  #
  # def connection
  #   self.class.connection
  # end
end
