class LikeResource < ApplicationResource
  attribute :user_id, :integer, only: [:filterable, :writable]
  attribute :recipe_id, :integer, only: [:filterable, :writable]

  belongs_to :recipe
end
