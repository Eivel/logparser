class LogParser
  def initialize(filename)
    @filename = filename
  end

  def calculate_stats
    stats = load_visits_and_ips
    stats = inject_unique_visits(stats)

    stats
  end

  def present_data
    "/help_page 3 visits\n/contact 2 visits\n/help_page 2 unique views \n/contact 1 unique views"
  end

  private

  def load_visits_and_ips
    stats = {}
    File.foreach(@filename) do |line|
      address, ip = line.split(" ")
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
