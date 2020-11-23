class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :name
      t.string :auth_token
      t.string :password_digest
      t.string :emailcode
      t.boolean :authenticated

      t.timestamps
    end
  end
end
