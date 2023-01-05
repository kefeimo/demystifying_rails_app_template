# frozen_string_literal: true

class Comment < ActiveRecord::Base
  validates_presence_of :body, :author
  belongs_to :post

  after_save :update_last_commented_on

  private

  def update_last_commented_on
    self.post.last_commented_on = self.created_at
    self.post.save

  end

end
