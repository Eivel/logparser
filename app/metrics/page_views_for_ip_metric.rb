require_relative 'base_metric'

# PageViewsForIPMetric calculates number of webpage visits
# for each ip in the provided lines.
class PageViewsForIPMetric < BaseMetric
  attr_accessor :stats

  def initialize
    @stats = {}
  end

  def process_line(line)
    line = super(line)
    address, ip = line.split(' ')
    if stats.key?(ip) && stats[ip][:addresses].key?(address)
      @stats[ip][:addresses][address] += 1
    elsif stats.key?(ip)
      @stats[ip][:addresses][address] = 1
    else
      @stats[ip] = { addresses: { address => 1 } }
    end
  end

  def text_output
    description = "Webpage views for each IP:\n"
    description + @stats
      .sort_by { |_, details| details[:addresses].length }
      .map { |ip, details| format_page_details(ip, details) }
      .reverse
      .join("\n")
  end

  private

  def format_page_details(ip, details)
    sorted_pages = sort_pages(details[:addresses])
    mapped_page_views = map_page_views(sorted_pages)
    joined_addresses = join_addresses(mapped_page_views)
    "#{ip}\n#{joined_addresses}\n"
  end

  def sort_pages(addresses)
    addresses.sort_by { |_, webpage| webpage }.reverse
  end

  def map_page_views(sorted_address_view_pairs)
    sorted_address_view_pairs.map do |webpage, views|
      "#{webpage} #{views} views"
    end
  end

  def join_addresses(sorted_address_view_strings)
    sorted_address_view_strings.join("\n")
  end
end
