require "./WebToPdf/*"
require "kemal"

get "/" do |env|
  env.response.content_type = "application/json"
  url = env.params.query["url"].to_s
  webname = url.sub(/^https?\:\/\//, "").sub(/^www./, "")
  webname = webname.split(".")[0]
  fname = "#{webname}_#{Time.now.epoch + Random.rand(2..10)}.pdf"
  `wkhtmltopdf #{url} ./public/#{fname}`
  {"status": "success", "path": "/#{fname}", "download_link": "#{Kemal.config.scheme}://#{Kemal.config.host_binding}:#{Kemal.config.port}/#{fname}"}.to_json
end

Kemal.config.port = 4000
Kemal.run
