module Asendia
  class Service

    def self.all
      [
        { name: 'Premium Goods', code: 'PTLP' },
        { name: 'Tracked Goods - Mailbox', code: 'FTGM' },
        { name: 'Tracked Goods - Personal', code: 'FTGP' },
        { name: 'DPD Express Pak', code: 'DPDEP' },
        { name: 'Colissimo Access FR', code: 'COLA' }
      ]
    end

    def self.find(service_code)
      all.find { |service| service[:code].downcase == service_code.downcase }
    end
  end
end
