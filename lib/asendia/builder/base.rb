require 'erb'
require 'cgi'

module Asendia
  module Builder
    class Base
      attr_accessor :authentication, :template_data

      def initialize(authentication, template_data)
        self.authentication = authentication
        self.template_data = template_data
        define_template_methods
      end

      def render_template
        render
      end

      private

      def format_value(value, max_length)
        value = value.to_s
        value = CGI.escape_html(value)
        value[0...(max_length || value.length)]
      end

      def define_template_methods
        template_data.keys.each do |key|
          define_singleton_method key do
            template_data[key]
          end
        end
      end

      def template
        @template ||= File.read(template_path)
      end

      def template_path
        File.join( File.dirname(__FILE__), "templates/_#{template_name}.xml.erb")
      end

      def render #TODO render with layout(including authentication and envelope by default)
        ERB.new(template).result(binding)
      end
    end
  end
end
