require 'helper'

RSpec.describe Hyperb::Image do

  describe '#created' do

    it 'returns timestamp when created is set' do
      image = Hyperb::Image.new(id: 1, created: 1420064636)
      expect(image.created).to be_a Fixnum
    end

    it 'returns nil when created is not set' do
      image = Hyperb::Image.new(id: 1)
      expect(image.created).to be_nil
    end
  end
end