module Rack
  class Request
    module Helpers

      alias origin_trusted_proxy? trusted_proxy?

      def trusted_proxy?(ip)
        return origin_trusted_proxy?(ip) unless ENV['TRUSTED_PROXY_PATTERN']
        @trusted_proxy_pattern ||= Regexp.new(ENV['TRUSTED_PROXY_PATTERN'])
        ip =~ @trusted_proxy_pattern
      end
    end
  end
end

module CanvasRails
  class Application
    if ENV['TRUSTED_PROXIES']
      require "ipaddr"
      trusted_proxies = ENV['TRUSTED_PROXIES'].split(',').map{|proxy| IPAddr.new proxy}
      config.action_dispatch.trusted_proxies = trusted_proxies
    end
  end
end
