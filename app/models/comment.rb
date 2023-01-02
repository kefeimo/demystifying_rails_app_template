# frozen_string_literal: true

class Comment < ActiveRecord::Base
  validates_presence_of :body, :author
  belongs_to :post

end
