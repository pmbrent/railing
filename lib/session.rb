require 'json'
require 'webrick'

class Session
  def initialize(req)

    if req.nil?
      existing_cookie = nil
    else
      existing_cookie = req.cookies.find do |cookie|
        cookie.name == '_rails_lite_app'
      end
    end

    @value = {}
    unless existing_cookie.nil?
       @value = JSON.parse(existing_cookie.value)
    end
  end

  def [](key)
    @value[key]
  end

  def []=(key, val)
    @value[key] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new("_rails_lite_app", @value.to_json)
    res.cookies << cookie
  end
end
