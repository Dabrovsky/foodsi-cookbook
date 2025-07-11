require 'rails_helper'

RSpec.describe "recipes#show", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/recipes/#{recipe.id}", params: params
  end

  describe 'basic fetch' do
    let!(:recipe) { create(:recipe) }

    it 'works' do
      expect(RecipeResource).to receive(:find).and_call_original
      make_request
      expect(response.status).to eq(200)
      expect(d.jsonapi_type).to eq('recipes')
      expect(d.id).to eq(recipe.id)
    end

    context 'total_likes_count' do
      let!(:like) { create(:like, recipe: recipe) }

      it 'returns the counter' do
        make_request
        expect(d.total_likes_count).to eq(1)
      end
    end
  end
end
