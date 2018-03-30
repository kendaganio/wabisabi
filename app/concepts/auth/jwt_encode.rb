module Auth
  class JWTEncode
    attr_reader :secret, :alg

    def initialize(secret = nil, alg = nil)
      @secret = secret || Rails.application.secrets.secret_key_base
      @alg = alg || 'HS256'
    end

    def call(payload)
      JWT.encode payload, secret, alg
    end

    def self.call(payload)
      new.call(payload)
    end
  end
end
