require "test_helper"

class RecordControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get record_index_url
    assert_response :success
  end
end
