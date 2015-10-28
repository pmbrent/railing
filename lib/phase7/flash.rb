require 'json'
require 'webrick'
require 'byebug'

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

  def empty?
    @new_values.empty? && @now_values.empty?
  end

  def []=(key, val)
    key = key.to_s
    @new_values[key] = val
  end

  def [](key)
    key = key.to_s
    if @new_values[key] && @now_values[key]
      @now_values[key] + "\n" + @new_values[key]
    else
      @new_values[key] ? @new_values[key] : @now_values[key]
    end
  end

  def now
    temp = Flash.new(@req)
    @now_values = @now_values.merge (temp.new_values)
  end

  def store_flash(res)
      cookie = WEBrick::Cookie.new("_rails_lite_flash", @new_values.to_json)
      cookie.path = '/'
      res.cookies << cookie
  end

end
