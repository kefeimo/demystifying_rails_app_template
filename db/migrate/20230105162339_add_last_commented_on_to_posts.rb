class AddLastCommentedOnToPosts < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :last_commented_on, :datetime
  end
end
