require 'hyperb/utils'

module Hyperb
  # helper for managing creating proper container host configs
  # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/create.html
  class HostConfig
    include Hyperb::Utils

    attr_accessor :binds, :links, :port_bindings, :publish_all_ports,
                  :network_mode, :restart_policy, :volume_driver, :log_config,
                  :readonly_rootfs, :volumes_from

    def initialize(params = {})
      params.each do |att, value|
        value = downcase_symbolize(value) if value.is_a?(Hash)
        instance_variable_set("@#{underscore(att)}", value)
      end
    end

    # returns a hash containing formated host config data
    #
    # @returns [Hash]
    def fmt
      formated = {}
      attrs.each_key do |key|
        formated[camelize(key)] = attrs[key]
      end
      formated
    end

    def attrs
      {
        binds: binds,
        links: links,
        port_bindings: port_bindings,
        publish_all_ports: publish_all_ports,
        network_mode: network_mode,
        restart_policy: restart_policy,
        volume_driver: volume_driver,
        log_config: log_config,
        readonly_rootfs: readonly_rootfs,
        volumes_from: volumes_from
      }
    end
  end
end
