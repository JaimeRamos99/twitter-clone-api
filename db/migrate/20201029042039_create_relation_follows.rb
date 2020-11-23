class CreateRelationFollows < ActiveRecord::Migration[6.0]
  def change
    create_table :relation_follows do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
  end
end
