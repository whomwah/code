module PrefsHelper
  def fetch_logo(network)
    image_tag(network.icon_path, :size => "16x16", :border => 0, :class => "icon")
  end
end
