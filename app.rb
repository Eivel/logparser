#!/usr/bin/env ruby

require_relative './app/logparser'
require_relative './app/metrics/page_views_for_ip_metric'
require_relative './app/metrics/unique_views_for_page_metric'
require_relative './app/metrics/visits_for_page_metric'

return puts 'You must provide a path to the input file.' if ARGV.empty?

filepath = ARGV[0]
begin
  puts LogParser.new(filepath).present_metrics(
    VisitsForPageMetric,
    UniqueViewsForPageMetric,
    PageViewsForIPMetric
  )
rescue IOError, RegexpError => e
  puts e.message
end
