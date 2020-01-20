# LogParser processes log files to produce general access stats.
class LogParser
  def initialize(filepath)
    raise IOError, 'File does not exist.' unless File.file?(filepath)

    @filepath = filepath
  end

  def calculate_stats
    stats = load_visits_and_ips
    stats = inject_unique_visits(stats)

    stats
  end

  def present_data
    stats = calculate_stats
    visits_output = stats
      .sort_by { |_, details| details[:visits] }
      .map { |address, details| "#{address} #{details[:visits]} visits" }
      .reverse
      .join("\n")

    unique_views_output = stats
      .sort_by { |_, details| details[:unique] }
      .map { |address, details| "#{address} #{details[:unique]} unique views" }
      .reverse
      .join("\n")

    "#{visits_output}\n#{unique_views_output}"
  end

  private

  def load_visits_and_ips
    stats = {}
    File.foreach(@filepath) do |line|
      address, ip = line.split(' ')
      if stats.key?(address)
        stats[address][:visits] += 1
        stats[address][:ips][ip] = true
      else
        stats[address] = {
          visits: 1,
          ips: { ip => true }
        }
      end
    end
    stats
  end

  def inject_unique_visits(stats)
    stats.each do |address, _|
      ips = stats[address].delete(:ips)
      stats[address][:unique] = ips.length
    end
  end
end
