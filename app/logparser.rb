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

    "#{visits_output(stats)}\n#{unique_views_output(stats)}"
  end

  private

  def visits_output(stats)
    stats
      .sort_by { |_, details| details[:visits] }
      .map { |address, details| "#{address} #{details[:visits]} visits" }
      .reverse
      .join("\n")
  end

  def unique_views_output(stats)
    stats
      .sort_by { |_, details| details[:unique] }
      .map { |address, details| "#{address} #{details[:unique]} unique views" }
      .reverse
      .join("\n")
  end

  def load_visits_and_ips
    stats = {}
    File.foreach(@filepath) do |line|
      check_line_format(line)
      address, ip = line.split(' ')
      stats[address] = update_stats(stats[address], ip)
    end
    stats
  end

  def update_stats(details, ip)
    if details
      details[:visits] += 1
      details[:ips][ip] = true
      details
    else
      {
        visits: 1,
        ips: { ip => true }
      }
    end
  end

  def check_line_format(line)
    regexp = %r{^\/\S+\s\d+\.\d+\.\d+\.\d+$}
    raise RegexpError, 'Incorrect line format.' unless regexp.match?(line)
  end

  def inject_unique_visits(stats)
    stats.each do |address, _|
      ips = stats[address].delete(:ips)
      stats[address][:unique] = ips.length
    end
  end
end
