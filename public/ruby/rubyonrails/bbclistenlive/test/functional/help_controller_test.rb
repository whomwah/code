require File.dirname(__FILE__) + '/../test_helper'
require 'help_controller'

# Re-raise errors caught by the controller.
class HelpController; def rescue_action(e) raise e end; end

class HelpControllerTest < Test::Unit::TestCase
  def setup
    @controller = HelpController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_help_page_get
    get :index
    assert_response 500
  end

  def test_help_page_post
    post :index
    assert_response :success
    assert_tag :tag => "div", :attributes => { :class => "main" }
    assert_template "help/index"
  end
end
