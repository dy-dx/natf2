require File.dirname(__FILE__) + '/../test_helper'
require 'uploads_controller'

# Re-raise errors caught by the controller.
class UploadsController; def rescue_action(e) raise e end; end

class UploadsControllerTest < Test::Unit::TestCase
  all_fixtures

  def setup
    @controller = UploadsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:uploads)
  end
  
  def test_should_get_index_if_logged_in
    login_as :trevor
    get :index
    assert_response :success
    assert assigns(:uploads)
  end

  def test_should_get_new
  end
  
  def test_should_create_upload
  end

  def test_should_show_upload
    get :show, :id => 1
    assert_response :redirect
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :redirect
  end
  
  def test_should_update_upload
    put :update, :id => 1, :upload => { }
    assert_response :redirect
  end
  
  def test_should_destroy_upload
    login_as :trevor
    old_count = Upload.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Upload.count
    assert_redirected_to files_home_path
  end
  
  def test_should_not_destroy_upload_if_not_authorized
    login_as :trevor
    old_count = Upload.count
    delete :destroy, :id => 2
    assert_equal old_count, Upload.count
    assert_redirected_to files_home_path
  end
  
end
