class Like < ApplicationRecord
  validates :user_id, uniqueness: { scope: :recipe_id }

  belongs_to :user
  belongs_to :recipe, counter_cache: :total_likes_count
end
