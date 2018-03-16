require "spec_helper"

RSpec.describe Asendia::Builder::Shipment, "#render_template" do
  let(:dummy_authentication) { { username: 'A-USER', password: 'SECURE-PASSWORD', unit_name: 'ASCENDIA' } }
  let(:shipment_data) do
    {
      shipment: {
        reference_number: 'DONT@ME',
        service_code: 'PTLP',
        secondary_reference: 'MEMEZ',
        email_alert: 'TRUE',
        documents_only: 'FALSE',
        invoice_number: '2+2-1=3',
        vat_number: '1222',

      },
      address: {
        reference_number: 'CUSTOMER-REFERENCE',
        company_name: 'MANS NOT HOT LIMTED',
        first_name: 'BIG',
        last_name: 'SHAQ',
        house_number: '21',
        street: '121 LYNX EFFECT',
        line_2: 'Quick Maths',
        city: 'LYNX-2+2-1',
        province: 'MY Province',
        post_code: 'CF123343',
        country: 'FR',
        phone: '123445555',
        mobile: '1233444433',
        email: 'big.shaq@man-not-hot.com'
      },
      parcel: {
        weight: '11',
        width: '22',
        height: '10',
        length: '14',
        contents: [
          {
            description: 'BIG BOX',
            quantity: '2',
            value: '12',
            weight: '12',
            currency: 'GBP',
            unit_weight: '1',
            country_of_origin: 'GBR',
            tariff_code: 'RTE'
          },
          {
            description: 'ANOTHER BIG BOX',
            quantity: '1',
            value: '10',
            weight: '5',
            currency: 'GBP',
            unit_weight: '1',
            country_of_origin: 'GBR',
            tariff_code: 'ETE'
          }
        ]
      }
    }
  end
  let(:shipment_xsd) { File.read(File.join( File.dirname(__dir__), "../fixtures/xsd/shipment.xsd")) }

  subject { described_class.new(dummy_authentication, shipment_data).render_template }

  context 'when the request is successful' do #Needs a valid xsd for validation
    xit 'returns a valid shipment XML schema' do
      xsd = Nokogiri::XML::Schema(shipment_xsd)
      doc = Nokogiri::XML(subject)

      xsd.validate(doc).each do |error|
        raise error.message
      end
    end

    it 'contains the correct shipment data' do
      shipment_data[:shipment].merge(shipment_data[:address]).merge(dummy_authentication).each do |key, value|
        expect(subject).to include value
      end
    end
  end
end
