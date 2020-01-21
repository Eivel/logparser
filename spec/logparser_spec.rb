require_relative 'spec_helper'
require_relative '../app/logparser'
require_relative '../app/metrics/visits_for_page_metric'
require_relative '../app/metrics/unique_views_for_page_metric'
require 'pry'

RSpec.describe LogParser do
  subject { described_class.new(filepath) }

  let(:filepath) do
    'spec/sample.log'
  end

  context 'raises error in case of non-existing file' do
    let(:filepath) { 'unavailable' }
    it 'returns correct error' do
      expect { subject }.to raise_error(IOError, 'File does not exist.')
    end
  end

  context 'process_file' do
    it 'returns metrics with processed stats' do
      metrics = [VisitsForPageMetric.new, UniqueViewsForPageMetric.new]
      metrics = subject.send(:process_file, metrics)

      aggregate_failures do
        expect(metrics[0].stats).to eq(
          '/help_page' => { visits: 4 },
          '/contact' => { visits: 2 }
        )
        expect(metrics[1].stats).to eq(
          '/help_page' => {
            ips: {
              '126.318.035.038' => true,
              '184.123.665.067' => true
            }
          },
          '/contact' => {
            ips: {
              '184.123.665.067' => true
            }
          }
        )
      end
    end
  end

  context 'present_metrics' do
    it 'returns metrics text output with processed stats' do
      metrics_classes = [VisitsForPageMetric, UniqueViewsForPageMetric]
      output = subject.send(:present_metrics, *metrics_classes)

      expect(output).to eq(
        "All visits for each webpage:\n"\
        "/help_page 4 visits\n/contact 2 visits"\
        "\n\n"\
        "Unique views for each webpage:\n"\
        "/help_page 2 unique views\n/contact 1 unique views"
      )
    end
  end
end
