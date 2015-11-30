require 'uri'

class Params
  def initialize(req, route_params = {})
    queries = req.query_string
    unless req.body.nil?
      queries.nil? ? queries = req.body : queries.concat(req.body)
    end
    @params = parse_www_encoded_form(queries)
    @params.nil? ? @params = route_params : @params.merge(route_params)
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

private

  def parse_www_encoded_form(www_encoded_form)
    return if www_encoded_form.nil?
    once_decoded = URI::decode_www_form(www_encoded_form)

    decoded = Hash.new

    once_decoded.each do |key, value|
      nest = parse_key(key)

      decoded = decoded.merge insert_value(decoded, nest, value)
    end
    decoded
  end

  def insert_value(hash, key_list, value)
    return value if key_list.size == 0
    if hash.has_key?(key_list[0])
      hash[key_list[0]].merge insert_value(hash[key_list[0]], key_list[1..-1], value)
    else
      return {key_list => value} if key_list.is_a?(String)
      temp = value
      key_list.reverse.each do |k|
        temp = { k => temp }
      end
      hash[temp.keys.first] = temp.values.first
      return hash
    end

  end

  def parse_key(key)
    splitkeys = key.split(/\]\[|\[|\]/)
    return key if splitkeys.size == 1
    splitkeys.map do |new_key|
      parse_key(new_key)
    end
  end
end
