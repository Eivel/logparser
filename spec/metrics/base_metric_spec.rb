require_relative '../spec_helper'
require_relative '../../app/metrics/base_metric'
require 'pry'

RSpec.describe BaseMetric do
  subject { described_class.new }

  let(:line) do
    '/help_page/1 126.318.035.038'
  end

  let(:lines) do
    File.readlines(filepath)
  end

  context 'parse_line' do
    context 'with corrupted line' do
      let(:corrupted_line) { '/help_page corrupted 126.318.035.038' }

      it 'returns error for the incorrect format' do
        expect { subject.process_line(corrupted_line) }.to raise_error(
          RegexpError,
          'Incorrect line format.'
        )
      end
    end

    context 'with correct line' do
      let(:correct_content_w_number) { '/help_page/1 126.318.035.038' }

      it 'does not return error for the correct format' do
        expect { subject.process_line(line) }.not_to raise_error
      end

      it 'does not return error for paths that contain number' do
        expect do
          subject.process_line(correct_content_w_number)
        end.not_to raise_error
      end
    end
  end
end
