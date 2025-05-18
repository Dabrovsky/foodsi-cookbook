require 'rails_helper'

RSpec.describe "likes#create", type: :request do
  let(:current_user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:payload) do
    {
      data: {
        type: 'likes',
        attributes: {
          recipe_id: recipe.id
        }
      }
    }
  end

  def make_authorized_request
    jsonapi_post "/api/v1/likes", payload, headers: { 'Authorization': current_user.token }
  end

  def make_unauthorized_request
    jsonapi_post "/api/v1/likes", payload
  end

  describe 'authenticated requests' do
    context 'with valid payload' do
      it 'creates a new like' do
        expect(LikeResource).to receive(:build).and_call_original
        expect {
          make_authorized_request
        }.to change { Like.count }.by(1)
      end

      it 'returns 201 status' do
        make_authorized_request
        expect(response.status).to eq(201)
      end

      it 'associates with current user' do
        make_authorized_request
        expect(Like.last.user).to eq(current_user)
      end

      it 'associates with specified recipe' do
        make_authorized_request
        expect(Like.last.recipe).to eq(recipe)
      end
    end

    context 'with invalid recipe_id' do
      before do
        payload[:data][:attributes][:recipe_id] = nil
      end

      it 'returns validation error' do
        make_authorized_request
        expect(response.status).to eq(422)
      end
    end

    context 'with duplicate like' do
      before do
        create(:like, user: current_user, recipe: recipe)
      end

      it 'returns validation error' do
        make_authorized_request
        expect(response.status).to eq(422)
        expect(response.body).to include('has already been taken')
      end
    end
  end

  describe 'unauthenticated requests' do
    it 'returns 401' do
      make_unauthorized_request
      expect(response.status).to eq(401)
      expect(response.body).to include('Unauthorized')
    end
  end
end
