require_relative "spec_helper"
require_relative "../app/logparser"

RSpec.describe LogParser do
  subject { described_class.new(filename) }

  let(:filename) do
    "test.log"
  end

  let(:data) do
    "/help_page 126.318.035.038
    /help_page 184.123.665.067
    /help_page 184.123.665.067
    /contact 184.123.665.067
    /contact 184.123.665.067"
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
