module Asendia
  class Response
    attr_accessor :parsed_response, :response, :action

    def initialize(response, action)
      @parsed_response = response.parsed_response["Envelope"]["Body"]
      @response = response.parsed_response["Envelope"]["Body"]["#{action}Response"]
      @action = action
    end

    def success?
      @success ||= (authenticated? && status == "Success")
    end

    def has_node?(name)
      response["OutputParameters"].values.first.find { |node| node["Name"] == name }
    end

    def node(name)
      return unless has_node?(name)

      response["OutputParameters"].values.first.find { |node| node["Name"] == name }["Value"]
    end

    def errors?
      !success?
    end

    def authenticated?
      return false if parsed_response["Fault"] && parsed_response["Fault"]["faultcode"]

      true
    end

    def errors
      return [] if success?

      return "Not Authorised, please check credentials" unless authenticated?
      response["ExitStatus"]["StatusDetails"].values.first["Message"]
    end

    private

    def status
      response["ExitStatus"] && response["ExitStatus"]["Status"]
    end
  end
end
