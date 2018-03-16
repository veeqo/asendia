module Asendia
  class Shipment
    attr_accessor :authentication, :attributes, :test_mode, :shipment, :errors

    def initialize(authentication, attributes, test_mode = true)
      @authentication = authentication
      @attributes = attributes
      @test_mode = test_mode
    end

    def create
      request = request_shipment
      response = Response.new(request, "PrintParcel")
      if response.success?
        tracking_number = response.node("Shipment.Identcode")
        reference_number = response.node("AA.UniqueReference")
        label = Base64.decode64(response.node("LABEL.#{tracking_number}.LabelPDF.PDF|Unicode.Label_#{tracking_number}_"))
        self.shipment = {
          label: label,
          tracking_number: tracking_number,
          reference_number: reference_number
        }
        true
      else
        self.errors = { error_message: response.errors }
        false
      end
    end

    private

    def request_shipment
      Request.new(:create_shipment, request_data, test_mode).request
    end

    def request_data
      @request_data ||= Builder::Shipment.new(authentication, attributes).render_template
    end
  end
end
