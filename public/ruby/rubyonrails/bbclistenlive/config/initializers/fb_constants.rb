# Include your application configuration below
APP_URL = "http://bbc-facebook.dyndns.org:2820"
APP_APIKEY = "2ed97045f95015a4dc0278547aba5dce"
FBOOK_APP_URL = "http://apps.facebook.com/bbclistenlive"
FB_SESSION_NON_EXIRES = "c853ed48673297269bf4d131-522101041"
FB_USER_ID = "522101041"
BBC = "http://www.bbc.co.uk"

# add my for date formatting
my_formats = {
  :hh_mm => "%H:%M"
}
ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(my_formats)