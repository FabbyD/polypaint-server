require 'test_helper'

class PixelCanvasesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get pixel_canvases_show_url
    assert_response :success
  end

end
