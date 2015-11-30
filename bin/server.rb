require 'active_support'
require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/flash'
require_relative '../models/'

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

# def flash_test
#   if flash[:messages]
#   <<-HTML.html_safe
#     #{flash[:messages]}
#     #{$cats.to_s}
#   HTML
#   end
# end

class CatsController < ControllerBase
  def create
    @cat = Cat.new(params["cat"])
    if @cat.save
      redirect_to("/cats")
    else
      render :new
    end
  end

  def index
    @cats = Cat.all
    render :index
  end

  def new
    @cat = Cat.new
    render :new
  end
end

class StatusesController < ControllerBase
  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params[:cat_id])
    end

    render_content(statuses.to_s, "text/text")
  end
end

class Cats2Controller < ControllerBase
  # def index
  #   render_content($cats.to_s, "text/text")
  # end

  def index
    render_content(flash_test, "html")
  end

  def tryflash
    flash[:messages] = "First/Second visit"
    flash.now[:messages] = "First visit only"
    render_content(flash_test, "html")
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
