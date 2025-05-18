require 'rails_helper'

RSpec.describe LikeResource, type: :resource do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe) }
  let(:payload) do
    {
      data: {
        type: 'likes',
        attributes: {
          user_id: user.id,
          recipe_id: recipe.id
        }
      }
    }
  end

  describe 'creating' do
    it 'works' do
      expect {
        expect(LikeResource.build(payload).save).to eq(true)
      }.to change { Like.count }.by(1)
    end

    it 'increments the recipe total likes counter' do
      expect {
        expect(LikeResource.build(payload).save).to eq(true)
      }.to change { recipe.reload.total_likes_count }.by(1)
    end

    context 'when duplicate like' do
      before { create(:like, user: user, recipe: recipe) }

      it 'fails validation' do
        like = LikeResource.build(payload)
        expect(like.save).to be(false)
        expect(like.data.errors[:user_id]).to include('has already been taken')
      end
    end

    context 'without user_id' do
      before do
        payload[:data][:attributes][:user_id] = nil
      end

      it 'fails validation' do
        like = LikeResource.build(payload)
        expect(like.save).to be(false)
        expect(like.data.errors[:user]).to include('must exist')
      end
    end

    context 'without recipe_id' do
      before do
        payload[:data][:attributes][:recipe_id] = nil
      end

      it 'fails validation' do
        like = LikeResource.build(payload)
        expect(like.save).to be(false)
        expect(like.data.errors[:recipe]).to include('must exist')
      end
    end
  end
end
