class User < ApplicationRecord

     include SlackTokenEncryptor

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, allow_nil: true

    has_secure_password

    def self.slack_token_encrypt(token)
        encrypt(token)
    end

    def self.slack_token_decrypt(token)
        decrypt(token)
    end
end
