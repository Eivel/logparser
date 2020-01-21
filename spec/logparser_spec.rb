require_relative 'spec_helper'
require_relative '../app/logparser'
require 'pry'

RSpec.describe LogParser do
  subject { described_class.new(filepath) }

  let(:filepath) do
    'spec/sample.log'
  end

  context 'check line for the proper format' do
    let(:corrupted_content) { '/help_page corrupted 126.318.035.038' }
    let(:correct_content_w_number) { '/help_page/1 126.318.035.038' }

    it 'returns error for the incorrect format' do
      allow(File).to receive(:foreach).and_yield(corrupted_content)
      expect { subject.calculate_stats }.to raise_error(
        RegexpError,
        'Incorrect line format.'
      )
    end

    it 'does not return error for the correct format' do
      expect { subject.calculate_stats }.not_to raise_error
    end

    it 'does not return error for paths that contain number' do
      allow(File).to receive(:foreach).and_yield(correct_content_w_number)
      expect { subject.calculate_stats }.not_to raise_error
    end
  end

  context 'raises error in case of non-existing file' do
    let(:filepath) { 'unavailable' }
    it 'returns correct error' do
      expect { subject }.to raise_error(IOError, 'File does not exist.')
    end
  end

  context 'calculate a number of visits' do
    it 'returns parsed data' do
      expect(subject.calculate_stats).to eq(
        '/help_page' => { visits: 3, unique: 2 },
        '/contact' => { visits: 2, unique: 1 }
      )
    end
  end

  context 'present data in the requested format' do
    it 'returns parsed data' do
      expect(subject.present_data).to eq(
        "/help_page 3 visits\n/contact 2 visits\n"\
          "/help_page 2 unique views\n/contact 1 unique views"
      )
    end
  end
end
