require "spec_helper"
require "pdf-reader"

RSpec.describe Asendia::Shipment, "#create" do
  let(:base_shipment_data) do
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
  let(:dummy_authentication) { { username: 'TEST-USER', password: 'SECURE-PASSWORD', unit_name: 'Asendia' } }
  let(:shipment) { described_class.new(dummy_authentication, shipment_data) }

  subject { shipment.create }

  before { subject }

  context 'when the shipment request is successful', vcr: { cassette_name: 'shipments/successful', match_requests_on: [:method, :uri, :body] } do
    let(:shipment_data) { base_shipment_data }

    it 'returns a shipment object' do
      expect(shipment.shipment).to include(tracking_number: '9L22490569553', reference_number: '10000n1682')
    end

    it 'returns a valid label' do
      label_file = File.open('test_label.pdf', 'wb') { |file| file.write(shipment.shipment[:label]) }
      reader = PDF::Reader.new("test_label.pdf")
      expect(reader.pdf_version).to eq(1.4)
      expect(reader.page_count).to eq(1)
      expect(reader.page(1).text.reverse).to include(shipment_data[:address][:street])
    end
  end

  context 'when the shipment request is unsuccessful', vcr: { cassette_name: 'shipments/unsuccessful', match_requests_on: [:method, :uri, :body] } do
    let(:shipment_data) do
      base_shipment_data.merge(parcel: base_shipment_data[:parcel].merge(weight: '0'))
    end

    it 'returns the shipment errors' do
      expect(shipment.errors).to include(error_message: "General printing error: Unable to generate XSC01 shipment: Shipment or Parcel weight must be more than 0.00kg;")
    end
  end

  context 'when the request is un-authorised', vcr: { cassette_name: 'shipments/un_authenticated', match_requests_on: [:method, :uri, :body] } do
    let(:shipment_data) { base_shipment_data }
    let(:dummy_authentication) { { username: 'HACKER-N00bie', password: 'GET-REKT', unit_name: 'H4CK3r' } }


    it 'returns an authentication error' do
      expect(shipment.errors).to include(error_message: 'Not Authorised, please check credentials')
    end
  end
end
