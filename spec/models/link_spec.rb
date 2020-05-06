require 'rails_helper'

RSpec.describe Link, type: :model do
  it 'generates a default code' do
    link = Link.create url: 'http://google.com'
    expect(link.code).to be_present
    expect(link.code.length).to eq(6)
  end

  describe 'to_json' do
    let(:valid_attributes) {{
      url: 'http://google.com',
      code: 'google'
    }}

    context 'links not visited' do
      it 'do not include last_usage' do
        link = Link.create valid_attributes
        expect(link.to_json).to include 'start_date'
        expect(link.to_json).to include 'usage_count'
        expect(link.to_json).to_not include 'last_usage'
      end
    end

    context 'links already visited' do
      it 'include last_usage' do
        link = Link.create valid_attributes
        link.increment_visits!
        expect(link.to_json).to include 'start_date'
        expect(link.to_json).to include 'usage_count'
        expect(link.to_json).to include 'last_usage'
      end
    end

  end
end
