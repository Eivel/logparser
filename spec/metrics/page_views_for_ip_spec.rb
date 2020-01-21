require_relative '../spec_helper'
require_relative '../../app/metrics/page_views_for_ip_metric'
require 'pry'

RSpec.describe PageViewsForIPMetric do
  subject { described_class.new }

  let(:line) do
    '/help_page/1 126.318.035.038'
  end

  let(:filepath) { 'spec/sample.log' }

  let(:lines) do
    File.readlines(filepath)
  end

  context 'process_line' do
    context 'with correct line' do
      it 'processes data correctly' do
        expect(subject.stats).to eq({})

        subject.process_line(lines[0])
        expect(subject.stats).to eq(
          '126.318.035.038' => {
            addresses: {
              '/help_page' => 1
            }
          }
        )

        subject.process_line(lines[1])
        subject.process_line(lines[2])
        expect(subject.stats).to eq(
          '126.318.035.038' => {
            addresses: {
              '/help_page' => 1
            }
          },
          '184.123.665.067' => {
            addresses: {
              '/help_page' => 2
            }
          }
        )

        subject.process_line(lines[3])
        subject.process_line(lines[4])
        subject.process_line(lines[5])

        expect(subject.stats).to eq(
          '126.318.035.038' => {
            addresses: {
              '/help_page' => 1
            }
          },
          '184.123.665.067' => {
            addresses: {
              '/help_page' => 3,
              '/contact' => 2
            }
          }
        )
      end
    end
  end

  context 'text_output' do
    before do
      lines.each { |l| subject.process_line(l) }
    end

    it 'returns parsed data' do
      expect(subject.text_output).to eq(
        "Webpage views for each IP:\n"\
        "184.123.665.067\n"\
        "/help_page 3 views\n"\
        "/contact 2 views\n"\
        "\n"\
        "126.318.035.038\n"\
        "/help_page 1 views\n"
      )
    end
  end
end
