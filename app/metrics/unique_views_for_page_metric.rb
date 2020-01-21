require_relative 'base_metric'

# UniqueViewsForPageMetric calculates number of unique views
# for each webpage in the provided lines.
class UniqueViewsForPageMetric < BaseMetric
  attr_accessor :stats

  def initialize
    @stats = {}
  end

  def process_line(line)
    line = super(line)
    address, ip = line.split(' ')
    if stats.key?(address)
      @stats[address][:ips][ip] = true
    else
      @stats[address] = { ips: { ip => true } }
    end
  end

  def text_output
    description = "Unique views for each webpage:\n"
    description + @stats
      .sort_by { |_, details| details[:ips].length }
      .map { |address, details| format_page_details(address, details) }
      .reverse
      .join("\n")
  end

  private

  def format_page_details(address, details)
    "#{address} #{details[:ips].length} unique views"
  end
end
