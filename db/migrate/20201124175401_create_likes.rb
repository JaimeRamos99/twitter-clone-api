class CreateLikes < ActiveRecord::Migration[6.0]
  def change
    create_table :likes do |t|
      t.reference :tweet
      t.reference :user

      t.timestamps
    end
  end
end
