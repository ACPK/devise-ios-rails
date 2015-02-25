require 'rails_helper'

describe 'OAuth' do
  include Rack::Test::Methods
  include_context 'format: json'

  describe 'user registration' do
    let(:params) do
      {
        user: {
          provider: 'facebook',
          oauth_token: 'token',
          uid: '1234'
        }
      }
    end

    it 'creates a new user' do
      expect do
        post 'v1/auth/facebook', params
      end.to change(User, :count).by(1)
    end

    context 'with existing provider and uid' do
      let!(:user) { create(:oauth_user) }

      it 'returns the existing user' do
        expect do
          post 'v1/auth/facebook', user: user.attributes
        end.not_to change(User, :count)
      end
    end
  end
end