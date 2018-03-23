module Asendia
  class Request
    attr_accessor :action, :request_xml, :test_mode

    def initialize(action, request_xml, test_mode)
      @action = action
      @request_xml = request_xml
      @test_mode = test_mode
    end

    def request
      request = HTTParty.post(endpoint, headers: headers, body: request_xml)
      request
    end

    private

    def endpoint
      test_mode? ? sandbox_endpoint : production_endpoint
    end

    def sandbox_endpoint
      "https://asendia.sandbox.mpm.metapack.net/Blackbox/BlackBox.svc"
    end

    def production_endpoint
      "https://asendia.mpm.metapack.com/BlackBox/BlackBox.svc"
    end

    def headers
      {
        "Content-Type" => "text/xml",
        "SOAPAction"  => "http://xlogics.eu/blackbox/BlackBoxContract/#{actions[action.to_sym]}"
      }
    end

    def actions
      {
        create_shipment: 'PrintParcel'
      }
    end

    alias :test_mode? :test_mode
  end
end
