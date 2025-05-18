class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    recipes = LikeResource.all(params.merge(filter: { user_id: current_user.id }, include: 'recipe'))
    respond_with(recipes)
  end

  def create
    like = LikeResource.build(create_params)

    if like.save
      render jsonapi: like, status: :created
    else
      render jsonapi_errors: like, status: :unprocessable_entity
    end
  end

  def destroy
    like = LikeResource.find(params)

    if like.destroy
      render jsonapi: like, status: :ok
    else
      render jsonapi_errors: like
    end
  end

  private

  def create_params
    params.to_unsafe_h.deep_merge(data: { attributes: { user_id: current_user.id } })
  end
end
