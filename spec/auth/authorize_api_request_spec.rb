require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  # Create test user
  subject(:invalid_request_obj) { described_class.new({}) }

  let(:request_obj) { described_class.new(header) }
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }

  # Mock `Authorization` header
  # Invalid request subject

  # Valid request subject

  # Test Suite for AuthorizeApiRequest#call
  # This is our entry point into the service class
  describe '#call' do
    # returns user object when request is valid
    context 'when valid request' do
      it 'returns user object' do
        result = request_obj.call
        expect(result[:user]).to eq(user)
      end
    end

    # returns error message when invalid request

    context 'when missing token' do
      it 'raises a MissingToken error' do
        expect { invalid_request_obj.call }
          .to raise_error(ExceptionHandler::MissingToken, 'Missing token')
      end
    end

    context 'when invalid token' do
      subject(:invalid_request_obj) do
        # custom helper method `token_generator`
        described_class.new('Authorization' => token_generator(5))
      end

      it 'raises an InvalidToken error' do
        expect { invalid_request_obj.call }
          .to raise_error(ExceptionHandler::InvalidToken, /Invalid token/)
      end
    end

    context 'when token is expired' do
      subject(:request_obj) { described_class.new(header) }

      let(:header) { { 'Authorization' => expired_token_generator(user.id) } }

      it 'raises ExceptionHandler::ExpiredSignature error' do
        expect { request_obj.call }
          .to raise_error(
            ExceptionHandler::InvalidToken,
            /Signature has expired/
          )
      end
    end

    context 'when fake token' do
      subject(:invalid_request_obj) { described_class.new(header) }

      let(:header) { { 'Authorization' => 'foobar' } }

      it 'handles JWT::DecodeError' do
        expect { invalid_request_obj.call }
          .to raise_error(
            ExceptionHandler::InvalidToken,
            /Not enough or too many segments/
          )
      end
    end
  end
end