require 'helper'

RSpec.describe Hyperb::Container do

  describe '#created' do

    it 'returns timestamp when created is set' do
      container = Hyperb::Container.new(id: '736cbb24edca6b366feb9975aaf34f330ba0d02b181d5227f8acb4a162b8fb44', created: 1420064636)
      expect(container.created).to be_a Fixnum
    end

    it 'returns nil when created is not set' do
      container = Hyperb::Container.new(id: 1)
      expect(container.created).to be_nil
    end
  end

  describe '#running?' do
    it 'returns false if container is not running' do
      container = Hyperb::Container.new(id: 1, state: 'stopped')
      expect(container.running?).to be false
    end
  end

end
