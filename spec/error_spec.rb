require "helper"

RSpec.describe Hyperb::Error do

  Hyperb::Error::ERRORS.each do |code, exception|
    it "#{exception}" do
    end
  end
end
