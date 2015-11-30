require 'active_support'
require 'active_support/core_ext'
require 'webrick'

require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/flash'
require_relative '../models/cat'
require_relative '../controllers/statuses'
require_relative '../controllers/cats2'

require 'byebug'

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

router = Router.new
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
