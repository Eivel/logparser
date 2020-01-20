#!/usr/bin/env ruby

require_relative './app/logparser'

return puts 'You must provide a path to the input file.' if ARGV.empty?

filepath = ARGV[0]
begin
  puts LogParser.new(filepath).present_data
rescue IOError => e
  puts e.message
end
