
module SlackTokenEncryptor

	extend ActiveSupport::Concern

	included do
	end

	module ClassMethods
		def encrypt(token)
			encryptor.encrypt_and_sign(token)	
		end

		def decrypt(encrypt_token)
			encryptor.decrypt_and_verify(encrypt_token)	
		end

		def encrypt_secret
			EasySettings.slack.token_encrypt_secret
		end

		def encryptor
			ActiveSupport::MessageEncryptor.new(encrypt_secret, encrypt_cipher)
		end

		def encrypt_cipher
			"aes-256-cbc"
		end
	end
	
end
