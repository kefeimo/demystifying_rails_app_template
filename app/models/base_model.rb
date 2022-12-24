# frozen_string_literal: true
class BaseModel

  attr_reader :errors

  def initialize(attributes={})

    @errors = {}
  end

  def new_record?
    id.nil?
  end

  def save
    # puts "======= save self #{self}"
    # puts "======= save self.class #{self.class}"
    # puts "======= save self.class.to_s #{self.class.to_s}"
    # puts "======= save self.to_s #{self.to_s}"
    return false unless valid?  # up to children class to implement

    if new_record?
      insert  # up to children class to implement
    else
      update  # up to children class to implement
    end
    return true
  end

  def self.connection
    db_connection = SQLite3::Database.new('db/development.sqlite3')
    db_connection.results_as_hash = true
    db_connection
  end

  def connection
    self.class.connection
  end


  def self.table_name
    to_s.pluralize.downcase
  end

  def self.all
    record_hashes = connection.execute "SELECT * FROM #{table_name}"
    records = record_hashes.map do |record_hash|
      # BaseModel.new(record_hash)
      # new(record_hash)  # gotchas: drop the class name for flexible inheritance
      self.new(record_hash)
    end
    # puts "============ records #{records}"
    p records
  end

  def destroy
    # Note: for object instance to evoke class method, use `self.class` syntax
    connection.execute "DELETE FROM #{self.class.table_name} WHERE #{self.class.table_name}.id = ?", id
  end

  def self.find(id)
    record_hash = connection.execute("SELECT * FROM #{table_name} WHERE #{table_name}.id = ? LIMIT 1", id).first
    new(record_hash)

  end


end
