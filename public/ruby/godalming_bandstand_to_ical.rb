#!/usr/bin/env ruby

# script that takes a url and creates an ical file 
# for all the 2009 Godalming band performances

require 'rubygems'
I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = true
require 'hpricot'
require 'open-uri'
require 'icalendar'
require 'date'
include Icalendar


URL = 'http://www.godalming-tc.gov.uk/page.htm?p=82'

def init
  data = fetch_bandstand_data 
  create_ical_using(data)
end

def fetch_bandstand_data
  doc = Hpricot.parse(open(URL))
  contents = (doc/"#content").inner_html.split('<br />')
  results = []

  contents.each do |str|
    str = str.strip
    if str =~ /^\d.*/ && str !~ /<strong>/
      # this needs to be split into date, title, desc
      str = str.gsub('"','') 
      str = str.gsub(/<em>|<\/em>/,'') 
      date, title = str.split(' - ')

      d = DateTime.parse(date)
      start_datetime = DateTime.new(d.year, d.month, d.day, 15, 00)
      end_datetime = DateTime.new(d.year, d.month, d.day, 17, 00)

      # create event and add to results 
      e = Event.new
      e.dtstart = start_datetime      
      e.dtend = end_datetime      
      e.summary = title
      e.location = 'Godalming Bandstand'

      results << e
    end
  end

  results
end

def create_ical_using(events)
  cal = Calendar.new

  events.each do |e|
    cal.add_event(e)
  end

  # We can output the calendar as a string to write to a file,
  # network port, database etc.
  cal_string = cal.to_ical
  puts cal_string
end

init
