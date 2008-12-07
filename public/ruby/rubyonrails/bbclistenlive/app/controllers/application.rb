# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  session :off
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_bbclistenlive_session_id'
  
  # session that won't expire = JWSURY
  # session key non-expired c853ed48673297269bf4d131-522101041
  
  def finish_facebook_login
    redirect_to :controller => "prefs"
  end
  
  private
  
  def check_for_http_post
    return five_hundred_page unless request.post?
  end
  
  def five_hundred_page
    render(:nothing => true, :status => 500)
  end
  
  def fb_redirect(url)
    %(<fb:redirect url="#{File.join(FBOOK_APP_URL, url)}" />)
  end
end
