class RadioController < ApplicationController
  before_filter :require_facebook_login, :except => [:play]
	before_filter :check_for_http_post
  layout "canvas"
  
  def mine
    @user = Fb.get_user_data(fbsession)
  end
  
  def friends
    friends = Fb.friends_get(fbsession)
    render_stats_page(friends)
  end
  
  def everyones
    render_stats_page
  end
  
  def play
		u = params[:u] ||= Fb.user_id(fbsession)
    @user = User.find_by_fbid(u)
    @network = Network.find(params[:n])
    if @user and @user.update_clicks( @network )
      link = @network.link_to_audio(@user, params[:f])
      redirect_to( link ) if link
    else
      render :text => "Problem found. Please re-save your settings!"
    end
  end
  
  private
  
  def render_stats_page(uids = nil)
    @user_rankings    = Preference.plays_ranking(:users => uids)
    @recent_listening = Preference.recent_listening(:users => uids)
    @pop_national     = Network.popular(:users => uids, :national => true)
    @pop_local        = Network.popular(:users => uids)
    @fav_national     = Network.favourite(:users => uids, :national => true)
    @fav_local        = Network.favourite(:users => uids)
    render :template => "radio/stats"
  end
end
