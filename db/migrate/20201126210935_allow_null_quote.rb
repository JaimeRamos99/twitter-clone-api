class AllowNullQuote < ActiveRecord::Migration[6.0]
  def change
    change_column :retweets, :quote, :string, :null => true
  end
end
