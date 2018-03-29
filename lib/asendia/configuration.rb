module Asendia
  class Configuration
    attr_accessor :log_requests

    def initialize
      @log_requests = false
    end

    def log_requests?
      @log_requests
    end
  end
end
