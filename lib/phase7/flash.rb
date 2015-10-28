require 'json'
require 'webrick'

class Flash

  attr_reader :new_values, :now_values

  def initialize(req)
    @req = req
    @new_values = {}
    @now_values = {}

    existing_cookie = req.cookies.find do |cookie|
      cookie.name == "_rails_lite_flash"
    end

    unless existing_cookie.nil?
      @now_values = JSON.parse(existing_cookie.value)
    end

  end

  def []=(key, val)
    @new_values[key] = val
  end

  def [](key)
    if !@now_values.empty? && !@new_values.empty?
      @now_values[key].concat(@new_values[key])  #assumes they're arrays
    else
      @now_values[key] if @now_values
      @new_values[key] if @new_values
    end
  end

  def now
    temp = Flash.new(@req, @res)
    @now_values = @now_values.merge (temp.new_values)
  end

  def store_flash(res)
    cookie = WEBrick::Cookie.new("_rails_lite_flash", @new_values.to_json)
    cookie.path = '/'
    res.cookies << cookie
  end

end
