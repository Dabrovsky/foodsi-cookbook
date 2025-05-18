require 'rails_helper'

RSpec.describe "likes#index", type: :request do
  let(:current_user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:params) { {} }

  def make_authorized_request
    jsonapi_get "/api/v1/likes", params: params, headers: { 'Authorization': current_user.token }
  end

  def make_unauthorized_request
    jsonapi_get "/api/v1/likes", params: params
  end

  describe 'authenticated requests' do
    context 'when user has no likes' do
      it 'returns successful empty response' do
        expect(LikeResource).to receive(:all).and_call_original
        make_authorized_request
        expect(response.status).to eq(200), response.body
        expect(d).to be_empty
      end
    end

    context 'when user has likes' do
      let!(:users_like) { create(:like, user: current_user) }
      let!(:others_like) { create(:like, user: other_user) }

      it 'returns only the current user likes' do
        make_authorized_request
        expect(response.status).to eq(200), response.body
        expect(d.map(&:jsonapi_type).uniq).to match_array(['likes'])
        expect(d.map(&:id)).to match_array([users_like.id])
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
