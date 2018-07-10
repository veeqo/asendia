require 'erb'

module Asendia
  module Builder
    class Shipment < Builder::Base

      private

      def nodes
        @nodes ||= [
          { name: 'Shipment.RefNo', value: shipment[:reference_number], mandatory: true, length: 40 },
          { name: 'AA.Service', value: shipment[:service_code], mandatory: true, length: 6 },
          { name: 'Shipment.ReturnValue', value: 'ShipmentIdentcode;AA.UniqueReference', mandatory: true, length: 36 },
          { name: 'AA.Reference2', value: shipment[:secondary_reference], mandatory: false  },
          { name: 'AA.EmailAlert', value: shipment[:email_alert], mandatory: false, length: 5 },
          { name: 'AA.DocumentsOnly', value: shipment[:documents_only], mandatory: false, length: 5  },
          { name: 'AA.ExportType', value: 'Merchandise', mandatory: false  },
          { name: 'AA.InvoiceNo', value: shipment[:invoice_number], mandatory: false  },
          { name: 'AA.VatNo', value: shipment[:vat_number], mandatory: false  },
          { name: 'Receiver.RefNo', value: address[:reference_number], mandatory: false, length: 20  },
          { name: 'Receiver.CompanyName', value: address[:company_name], mandatory: false, length: 40  },
          { name: 'Receiver.Name1', value: address[:first_name], mandatory: true, length: 40  },
          { name: 'Receiver.Name2', value: address[:last_name], mandatory: true, length: 40  },
          { name: 'Receiver.HouseNo', value: address[:house_number], mandatory: false, length: 16 },
          { name: 'Receiver.Street', value: address[:street], mandatory: true, length: 100 },
          { name: 'Receiver.AddressDetails', value: address[:line_2], mandatory: false, length: 100 },
          { name: 'Receiver.City', value: address[:city], mandatory: false, length: 40 },
          { name: 'Receiver.Province', value: address[:province], mandatory: false, length: 50 },
          { name: 'Receiver.Postcode', value: address[:post_code], mandatory: true, length: 16 },
          { name: 'Receiver.Country', value: address[:country], mandatory: true, length: 100 },
          { name: 'Receiver.Telephone', value: address[:phone], mandatory: false, length: 30 },
          { name: 'Receiver.Mobile', value: address[:mobile], mandatory: false, length: 30 },
          { name: 'Receiver.Email', value: address[:email], mandatory: false, length: 50 },
          { name: 'Receiver.Email', value: address[:email], mandatory: false, length: 50 },
          { name: 'Parcel.Weight', value: parcel[:weight], mandatory: true },
          { name: 'Parcel.Width', value: parcel[:width], mandatory: false },
          { name: 'Parcel.Height', value: parcel[:height], mandatory: false },
          { name: 'Parcel.Length', value: parcel[:length], mandatory: false },
        ]
      end

      def parcel_contents_nodes
        @parcel_contents_nodes ||= parcel[:contents].map.with_index(1) do |product, index|
          [
            { name: 'ASLineItemNo', value: index.to_s, mandatory: false },
            { name: 'ASProductDesc', value: product[:description], mandatory: false, length: 255 },
            { name: 'ASUnitQuantity', value: product[:quantity], mandatory: false },
            { name: 'ASUnitValue', value: product[:value], mandatory: false },
            { name: 'ASCurrency', value: product[:currency], mandatory: false },
            { name: 'ASUnitWeight', value: product[:unit_weight], mandatory: false },
            { name: 'ASCountry', value: product[:country_of_origin], mandatory: false },
            { name: 'ASHSTariff', value: product[:tariff_code], mandatory: false, length: 50 },
          ]
        end
      end

      def template_name
        'shipment'
      end
    end
  end
end
