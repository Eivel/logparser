# BaseMetric provides shared metric methods and validations.
class BaseMetric
  def process_line(line)
    line = line.strip
    check_line_format(line)
    line
  end

  private

  def check_line_format(line)
    regexp = %r{^\/\S+\s\d+\.\d+\.\d+\.\d+$}
    raise RegexpError, 'Incorrect line format.' unless regexp.match?(line)
  end
end
