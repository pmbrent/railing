require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './params'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Already built!" if @already_built_response
    flash.store_flash(res)
    @res["Location"] = url
    @res.status = 302
    @already_built_response = true
    session.store_session(@res)
    @res
  end

  def render_content(content, content_type)
    raise "Already built!" if @already_built_response
    flash.store_flash(res)
    @res.content_type = content_type
    @res.body = content
    @already_built_response = true
    session.store_session(@res)
    @res
  end

  def render(template_name)
    controller_name = self.class.to_s.underscore

    temp = File.read "views/#{controller_name}/#{template_name}.html.erb"

    the_result = ERB.new(temp).result(binding)

    render_content(the_result, "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req)
  end

  def invoke_action(name)
    unless @already_built_response
      self.send(name)
    end
  end
end
