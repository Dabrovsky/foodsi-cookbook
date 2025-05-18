class RecipeResource < ApplicationResource
  attribute :title, :string
  attribute :text, :string
  attribute :difficulty, :string
  attribute :preparation_time, :integer
  attribute :total_likes_count, :integer, readonly: true
  attribute :created_at, :datetime

  belongs_to :author
  many_to_many :categories
  has_many :likes
end
