class AddIndexToLikes < ActiveRecord::Migration[7.0]
  def change
    add_index :likes, [:user_id, :recipe_id], unique: true
  end
end
