require 'webrick'
require 'json'

class Handler < WEBrick::HTTPServlet::AbstractServlet

  def cors(res)
    res['Access-Control-Allow-Origin'] = '*'
    res["Access-Control-Allow-Headers"] = "Origin, X-Requested-With, Content-Type, Accept"
  end

  def do_GET req, res
    cors res
    res.body = {sites: $sites}.to_json + "\n"
  end

  def do_POST req, res
    cors res
    json = JSON(req.body)['site']
    json['id'] = ($sites.map{|s|s['id']}.max || 0) + 1
    $sites << json
    res.body = {site: json}.to_json + "\n"
  end

  def do_OPTIONS req, res
    cors res
    super
  end
end

server = WEBrick::HTTPServer.new Port: 8080

$sites = []

trap 'INT' do
  server.shutdown
end

server.mount '/api/sites', Handler

server.start
