shared_examples 'a valid api request' do
  it 'responds with 200 - ok' do
    expect(last_response.status).to eq(200)
  end
end

shared_examples 'a correct payload' do
  it 'has correct payload' do
    expect(json['data']['attributes']).to include(payload)
      .and(include('updated_at', 'created_at'))
  end
end

shared_examples 'an invalid api request' do
  it 'responds with 422 - unprocessable entity' do
    expect(last_response.status).to eq(422)
  end

  it 'has error in the payload' do
    expect(json.key?('errors')).to be_truthy
  end
end

shared_examples 'a resource was not found' do
  it 'responds with 404 - not found' do
    expect(last_response.status).to eq(404)
  end

  it 'has correct message' do
    expect(json['errors']).to include(/not found/)
  end
end

shared_examples 'an unauthenticated endpoint' do |endpoint|
  describe "GET #{endpoint}" do
    it 'responds with 401 - unauthorized' do
      get endpoint
      expect(last_response.status).to eq(401)
    end
  end

  describe "POST #{endpoint}" do
    it 'responds with 401 - unauthorized' do
      post endpoint, {}
      expect(last_response.status).to eq(401)
    end
  end

  describe "GET #{endpoint}/:id" do
    it 'responds with 401 - unauthorized' do
      get "#{endpoint}/1"
      expect(last_response.status).to eq(401)
    end
  end

  describe "DELETE #{endpoint}/:id" do
    it 'responds with 401 - unauthorized' do
      delete "#{endpoint}/1"
      expect(last_response.status).to eq(401)
    end
  end
end
