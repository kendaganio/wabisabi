module Auth
  class JWTDecode
    attr_reader :token, :secret, :alg

    def initialize(secret = nil, alg = nil)
      @secret = secret || Rails.application.secrets.secret_key_base
      @alg = alg || 'HS256'
    end

    def call(token)
      JWT.decode token, secret, true, algorithm: alg
    end

    def self.call(token)
      new.call(token)
    end
  end
end
