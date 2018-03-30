describe '/api/v1/auth' do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'POST /' do
    context 'valid user' do
      it 'returns token' do
        create(:test_user)

        post '/api/v1/auth',
          params: { email: 'login@mailinator.com', password: 'loginpass' },
          headers: headers

        json = JSON.parse(response.body)
        expect(json['token']).to_not be_nil
      end
    end
  end
end
