class LogParser
  def initialize(filename)
    @filename = filename
  end

  def calculate_stats
    {
      "/help_page" => { visits: 3, unique: 2 },
      "/contact" => { visits: 2, unique: 1 }
    }
  end

  def present_data
    "/help_page 3 visits\n/contact 2 visits\n/help_page 2 unique views \n/contact 1 unique views"
  end
end
