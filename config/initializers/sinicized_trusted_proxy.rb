module Rack
  class Request
    module Helpers

      alias origin_trusted_proxy? trusted_proxy?

      def trusted_proxy?(ip)
        return origin_trusted_proxy?(ip) unless ENV['TRUSTED_PROXY']
        @trusted_proxy_pattern ||= Regexp.new(ENV['TRUSTED_PROXY'])
        ip =~ @trusted_proxy_pattern
      end
    end
  end
end
