require "spec_helper"

RSpec.describe Asendia::Service do

  describe '#all' do
    subject { described_class.all }

    it 'returns valid Asendia services' do
      expect(subject.length).to eq(5)
      expect(subject).to match_array([
        { name: 'Premium Goods', code: 'PTLP' },
        { name: 'Tracked Goods - Mailbox', code: 'FTGM' },
        { name: 'Tracked Goods - Personal', code: 'FTGP' },
        { name: 'DPD Express Pak', code: 'DPDEP' },
        { name: 'Colissimo Access FR', code: 'COLA' }
      ])
    end
  end

  describe '#find' do
    subject { described_class.find("cola") }

    it 'returns the service' do
      expect(subject).to eq({ name: 'Colissimo Access FR', code: 'COLA' })
    end
  end
end
