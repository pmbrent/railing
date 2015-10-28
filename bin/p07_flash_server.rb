require 'webrick'
require_relative '../lib/phase7/controller_base'
require_relative '../lib/phase6/router'
require_relative '../lib/phase7/flash'
require 'byebug'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

def flash_test
  if flash[:messages]
  <<-HTML.html_safe
    #{flash[:messages]}
    #{$cats.to_s}
  HTML
  end
end

class StatusesController < Phase7::ControllerBase
  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params[:cat_id])
    end

    render_content(statuses.to_s, "text/text")
  end
end

class Cats2Controller < Phase7::ControllerBase
  def index
    render_content(flash_test, "html")
  end

  def tryflash
    flash[:messages] = "First/Second visit"
    flash.now[:messages] = "First visit only"
    render_content(flash_test, "html")
  end

end

router = Phase6::Router.new
router.draw do
  get Regexp.new("^/cats/flash$"), Cats2Controller, :tryflash
  get Regexp.new("^/cats$"), Cats2Controller, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
