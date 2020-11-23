class AddUniqueIndexToFollows < ActiveRecord::Migration[6.0]
  def change
    add_index :relation_follows, [:follower_id, :followed_id], unique: true
  end
end
