class ClientEvent
    MNOITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect']
    def incoming(message, callback)
        return callback.call(message) unless MONITORED_CHANNEL.include? message['channel']

        puts message.inspect
        callback.call(message)

    end
    def outgoing(message, callback)
        callback.call(message)
    end
    def faye_client
        @faye_client ||= Faye::Client.new('http://localhosta:9292/faye')
    end
end
