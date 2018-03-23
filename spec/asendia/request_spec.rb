require "spec_helper"
require "pdf-reader"

RSpec.describe Asendia::Request, "#endpoint" do

  subject { described_class.new({}, "", test_mode).send(:endpoint) }

  before { subject }

  context 'when test mode is true' do
    let(:test_mode) { true }

    it 'uses the correct test endpoint' do
      expect(subject).to eq("https://asendia.sandbox.mpm.metapack.net/Blackbox/BlackBox.svc")
    end
  end

  context 'when test mode is false' do
    let(:test_mode) { false }

    it 'uses the correct production endpoint' do
      expect(subject).to eq("https://asendia.mpm.metapack.com/BlackBox/BlackBox.svc")
    end
  end
end
