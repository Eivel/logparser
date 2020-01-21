# LogParser processes log files to produce selected metrics output.
class LogParser
  def initialize(filepath)
    raise IOError, 'File does not exist.' unless File.file?(filepath)

    @filepath = filepath
  end

  def present_metrics(*metric_classes)
    metrics = initialize_metrics(metric_classes)
    metrics = process_file(metrics)
    metrics.map(&:text_output).join("\n\n")
  end

  private

  def initialize_metrics(metric_classes)
    metric_classes.map(&:new)
  end

  def process_file(metrics)
    File.foreach(@filepath) do |line|
      metrics.each do |metric|
        metric.process_line(line)
      end
    end
    metrics
  end
end
