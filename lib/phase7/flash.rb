require 'json'
require 'webrick'

class Flash

  attr_reader :new_values, :now_values

  def initialize(req, res)
    @req = req
    @res = res
    @cookie = WEBrick::Cookie.new("_rails_lite_flash", "")
    @cookie.path = '/'
    @new_values = {}
    @now_values = {}

    if req.nil?
      existing_cookie = nil
    else
      existing_cookie = req.cookies.find do |cookie|
        cookie.name == '_rails_lite_app'
      end
    end

    unless existing_cookie.nil?
       @now_values = JSON.parse(existing_cookie.value)
    end

  end

  def []=(key, value)
    @new_values[key] = value
  end

  def [](key)
    @now_values[key].concat(@new_values[key])  #assumes they're arrays
  end

  def now
    temp = Flash.new(@req, @res)
    @now_values = @now_values.merge (temp.new_values)
  end

  def save
    @new_values #only these are saved back for next session
  end

end
