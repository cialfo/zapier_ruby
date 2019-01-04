module ZapierRuby
  class Zapper
    attr_accessor :zap_name, :logger, :opt_hash

    def initialize(zap_name, web_hook_id=nil, opt_hash={})
      self.zap_name = zap_name
      self.logger = LoggerDecorator.new(config.enable_logging)
      @zap_web_hook = web_hook_id if web_hook_id
      self.opt_hash = init_opt_hash(opt_hash)
    end

    def zap(params={})
      unless zap_web_hook_id
        raise ZapierMisConfiguration, "No zap configured for #{zap_name}. Configured webhooks: #{config.web_hooks.to_s}"
      end

      logger.debug "Zapping #{zap_name} with params: #{params.to_s}"
      post_zap(params)
    end

    private

    def init_opt_hash(opt_hash)
      opt_hash[:hook_path] ||= 'catch'
      opt_hash
    end

    def post_zap(params)
      rest_client.post(params, zap_headers)
    rescue RestClient::ExceptionWithResponse => err
      raise ZapierServerError, err
    end

    def rest_client
      @rest_client ||= RestClient::Resource.new(zap_url, ssl_version: 'TLSv1')
    end

    def zap_web_hook_id
      @zap_web_hook ||= config.web_hooks[zap_name]
    end
    private :zap_web_hook_id

    def zap_headers
      {
        "Accept" => " application/json",
        "Content-Type" => "application/json"
      }
    end

    def hook_path
      "#{opt_hash[:hook_path]}"
    end

    def zap_url
      "#{config.base_uri}#{hook_path}/#{zap_web_hook_id}/"
    end

    def config
      ZapierRuby.config
    end
  end
end
