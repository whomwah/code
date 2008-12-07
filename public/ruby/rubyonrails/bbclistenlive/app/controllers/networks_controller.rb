class NetworksController < ApplicationController
  before_filter :require_facebook_login, :check_for_http_post, :handle_friends
  helper :radio
  layout "canvas"
  
  private
  
  def handle_friends
    if params[:id] == "friends"
      @uids = Fb.friends_get(fbsession)
    else
      @uids = nil
    end
  end
end
