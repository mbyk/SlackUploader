Sidekiq.configure_server do |config|
	config.redis = { url: 'redis://localhost:6380', namespace: 'upload_sidekiq' }
end

Sidekiq.configure_client do |config|
	config.redis = { url: 'redis://localhost:6380', namespace: 'upload_sidekiq'  }
end


