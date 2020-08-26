require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { valid_headers.except('Authorization') }

  # User signup test suite
  describe 'POST /v1/signup' do
    let(:valid_attributes) { { email: 'maru@email.com', password: '123456' }.to_json }

    context 'when valid request' do
      before { post '/v1/signup', params: valid_attributes, headers: headers }

      it 'creates a new user' do
        expect(response).to have_http_status(:created)
      end

      it 'returns success message' do
        expect(json['message']).to match(/Account created successfully/)
      end

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when invalid request' do
      before { post '/v1/signup', params: {}, headers: headers }

      it 'does not create a new user' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns failure message' do
        expect(json['message'])
          .to match(/Validation failed: Password can't be blank, Email can't be blank, Email is invalid, Password digest can't be blank/)
      end
    end
  end
end