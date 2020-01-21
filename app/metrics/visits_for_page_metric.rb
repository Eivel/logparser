require_relative 'base_metric'

# VisitsForPageMetric calculates number of visits
# for each webpage in the provided lines.
class VisitsForPageMetric < BaseMetric
  attr_accessor :stats

  def initialize
    @stats = {}
  end

  def process_line(line)
    line = super(line)
    address, = line.split(' ')
    if stats.key?(address)
      @stats[address][:visits] += 1
    else
      @stats[address] = { visits: 1 }
    end
  end

  def text_output
    description = "All visits for each webpage:\n"
    description + @stats
      .sort_by { |_, details| details[:visits] }
      .map { |address, details| format_page_details(address, details)}
      .reverse
      .join("\n")
  end

  private

  def format_page_details(address, details)
    "#{address} #{details[:visits]} visits"
  end
end
