class HelpController < ApplicationController
  before_filter :check_for_http_post
  caches_page :index, :ie, :ff, :camino, :safari, :popups
  layout "canvas"
end
