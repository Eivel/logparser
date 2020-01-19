require_relative "spec_helper"
require_relative "../app/logparser"
require "pry"

RSpec.describe LogParser do
  subject { described_class.new(filename) }

  let(:filename) do
    "spec/sample.log"
  end

  context "calculate a number of visits" do
    it "returns parsed data" do
      expect(subject.calculate_stats).to eq(
        {
          "/help_page" => { visits: 3, unique: 2 },
          "/contact" => { visits: 2, unique: 1 }
        }
      )
    end
  end

  context "present data in the requested format" do
    it "returns parsed data" do
      expect(subject.present_data).to eq(
        "/help_page 3 visits\n/contact 2 visits\n/help_page 2 unique views \n/contact 1 unique views"
      )
    end
  end
end
