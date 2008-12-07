require File.dirname(__FILE__) + '/../test_helper'
require 'networks_controller'

# Re-raise errors caught by the controller.
class NetworksController 
  def rescue_action(e) raise e end
  def require_facebook_login; end
end

class NetworksControllerTest < Test::Unit::TestCase
  fixtures :users, :preferences, :networks
    
  def setup
    @controller = NetworksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_the_gets
    [:usage, :popular, :listeners, :favourite].each do |page|
      get page
      assert :error
    end
  end
end
