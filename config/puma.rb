_app_path = "#{File.expand_path("../..", __FILE__)}"
_app_name = File.basename(_app_path)
_home = ENV.fetch("HOME") { "/Users/maru" }
pidfile "#{_home}/run/#{_app_name}.pid"
bind "unix://#{_home}/run/#{_app_name}.sock"
directory _app_path
