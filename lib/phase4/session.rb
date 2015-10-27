require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      existing_cookie = req.cookies.find do |cookie|
        cookie.name == '_rails_lite_app'
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

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new("_rails_lite_app", @value.to_json)
      res.cookies << cookie
    end
  end
end
