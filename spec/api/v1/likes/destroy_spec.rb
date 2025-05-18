require 'rails_helper'

RSpec.describe "likes#destroy", type: :request do
  let(:current_user) { create(:user) }
  let!(:like) { create(:like, user: current_user) }

  def make_authorized_request
    jsonapi_delete "/api/v1/likes/#{like.id}", headers: { 'Authorization': current_user.token }
  end

  def make_unauthorized_request
    jsonapi_delete "/api/v1/likes/#{like.id}"
  end

  describe 'authenticated requests' do
    it 'destroys the resource' do
      expect(LikeResource).to receive(:find).and_call_original
      expect {
          make_authorized_request
        }.to change { Like.count }.by(- 1)
      expect { like.reload }
        .to raise_error(ActiveRecord::RecordNotFound)
      expect(response.status).to eq(200)
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
