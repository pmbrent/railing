require_relative '../phase6/controller_base'

module Phase7
  class ControllerBase < Phase6::ControllerBase
    def redirect_to(url)
      flash.store_flash(res)
      super(url)
    end

    def render_content(content, content_type)
      flash.store_flash(res)
      super(content, content_type)
    end

    # method exposing a `Flash` object
    def flash
      @flash ||= Flash.new(req)
    end

  end
end
