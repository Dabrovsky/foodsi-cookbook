class AddTotalLikesCountToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :total_likes_count, :integer, default: 0, null: false
    up_only do
      execute <<~SQL
        UPDATE recipes
        SET total_likes_count = (
          SELECT COUNT(*)
          FROM likes
          WHERE likes.recipe_id = recipes.id
        )
      SQL
    end
  end
end
