require_relative '../spec_helper'
require_relative '../../app/metrics/visits_for_page_metric'
require 'pry'

RSpec.describe VisitsForPageMetric do
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

        lines.each { |l| subject.process_line(l) }

        expect(subject.stats).to eq(
          '/help_page' => { visits: 4 },
          '/contact' => { visits: 2 }
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
        "All visits for each webpage:\n"\
        "/help_page 4 visits\n/contact 2 visits"
      )
    end
  end
end
