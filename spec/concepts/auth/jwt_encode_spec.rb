require 'rails_helper'

describe Auth::JWTEncode do
  subject { Auth::JWTEncode }

  it 'can be decoded by JWTDecode' do
    payload = { 'lol' => 'ok' }
    token = subject.call(payload)

    expect(Auth::JWTDecode.call(token).first).to eq(payload)
  end
end
