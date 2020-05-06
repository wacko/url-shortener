require 'rails_helper'

RSpec.describe Link, type: :model do
  it 'generates a default code' do
    link = Link.create url: 'http://google.com'
    expect(link.code).to be_present
    expect(link.code.length).to eq(6)
  end
end
