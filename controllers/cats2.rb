class Cats2Controller < ControllerBase
  def index
    render_content(flash_test, "html")
  end

  def tryflash
    flash[:messages] = "First/Second visit"
    flash.now[:messages] = "First visit only"
    render_content(flash_test, "html")
  end
end
