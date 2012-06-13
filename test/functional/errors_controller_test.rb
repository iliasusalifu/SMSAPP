require 'test_helper'

class ErrorsControllerTest < ActionController::TestCase
  test "should get routing" do
    get :routing
    assert_response :success
  end

end
