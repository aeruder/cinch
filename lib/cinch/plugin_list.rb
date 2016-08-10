require 'monitor'

module Cinch
  # @since 2.0.0
  class PluginList < Array
    attr_accessor :monitor

    def initialize(bot)
      @bot     = bot
      @monitor   = Monitor.new
      super()
    end

    # @param [Class<Plugin>] plugin
    def register_plugin(plugin)
      monitor.synchronize {
        self << plugin.new(@bot)
      }
    end

    # @param [Array<Class<Plugin>>] plugins
    def register_plugins(plugins)
      monitor.synchronize {
        plugins.each { |plugin| register_plugin(plugin) }
      }
    end

    # @since 2.0.0
    def unregister_plugin(plugin)
      monitor.synchronize {
        plugin.unregister
        delete(plugin)
      }
    end

    def unregister_plugin_class(plugin)
      monitor.synchronize {
        self.dup.each { |x| unregister_plugin(x) if x.is_a? plugin }
      }
    end

    # @since 2.0.0
    def unregister_plugins(plugins)
      monitor.synchronize {
        if plugins == self
          plugins = self.dup
        end
        plugins.each { |plugin| unregister_plugin(plugin) }
      }
    end

    # @since 2.0.0
    def unregister_all
      unregister_plugins(self)
    end
  end
end
