require 'rails_helper'

RSpec.describe "recipes#index", type: :request do
  let(:params) { {} }

  subject(:make_request) do
    jsonapi_get "/api/v1/recipes", params: params
  end

  describe 'basic fetch' do
    let!(:recipe1) { create(:recipe) }
    let!(:recipe2) { create(:recipe) }

    it 'works' do
      expect(RecipeResource).to receive(:all).and_call_original
      make_request
      expect(response.status).to eq(200), response.body
      expect(d.map(&:jsonapi_type).uniq).to match_array(['recipes'])
      expect(d.map(&:id)).to match_array([recipe1.id, recipe2.id])
    end

    context 'total_likes_count' do
      let!(:like) { create(:like, recipe: recipe2) }

      it 'returns the counter' do
        make_request
        expect(d.map(&:total_likes_count)).to match_array([0, 1])
      end
    end
  end
end
