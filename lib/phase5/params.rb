require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = parse_www_encoded_form(req.query_string)
    end

    def [](key)
      @params[key]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      once_decoded = URI::decode_www_form(www_encoded_form)

      decoded = Hash.new

      once_decoded.each do |key, value|
        nest = parse_key(key)

        decoded.merge insert_value(decoded, nest, value)

      end
      decoded
    end

    def insert_value(hash, key_list, value)
      return value if key_list.size == 0

      if hash.has_key?(key_list[0])
        hash[key_list[0]].merge insert_value(hash[key_list[0]], key_list[1..-1], value)
      else
        temp = value
        key_list.reverse.each do |k|
          temp = { k => temp }
        end
        hash[temp.keys.first] = temp.values.first
        return hash
      end

    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      splitkeys = key.split(/\]\[|\[|\]/)
      return key if splitkeys.size == 1
      splitkeys.map do |new_key|
        parse_key(new_key)
      end
    end
  end
end
