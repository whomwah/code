require "rubygems"

begin
  require "rfacebook_on_rails/plugin/init"
rescue Exception => e
  puts "There was a problem loading the RFacebook on Rails plugin.  You may have forgotten to install the RFacebook Gem."
  raise e
end

# simple patch to fix the fact the Rail 2.0 RC1 alias the image_path helper method
module RFacebook::Rails::Plugin
  module ViewExtensions
    def path_to_image(*params)
      path = super(*params)
      if ((in_facebook_canvas? or in_mock_ajax?) and !(/(\w+)(\:\/\/)([\w0-9\.]+)([\:0-9]*)(.*)/.match(path)))
        path = "#{request.protocol}#{request.host_with_port}#{path}"
      end
      return path
    end
  end
end
ActionView::Base.send(:include, RFacebook::Rails::Plugin::ViewExtensions)


module RFacebook::Rails::Plugin
  module ControllerExtensions
		def facebook_debug_panel(options={})
			"Oops, something went wrong"
		end
	end
end
ActionController::Base.send(:include, RFacebook::Rails::Plugin::ControllerExtensions)
