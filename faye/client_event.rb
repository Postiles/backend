class ClientEvent
    MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect']
    CHANNEL_BOARD_REGEX = /\/faye\/\d+/ # match pattern of /faye/num

    def incoming(message, callback)
        return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']

        if MONITORED_CHANNELS[0].eql? message['channel']
          puts "New subscription"
          puts message.inspect
          if CHANNEL_BOARD_REGEX.match(message['subscription'])
            puts "subscription:"+ message['subscription']
            puts "id:"+message['id']
          end
        else
          puts "Disconnect"+message['id']
        end
        callback.call(message)

    end
    def outgoing(message, callback)
        callback.call(message)
    end
    def faye_client
        @faye_client ||= Faye::Client.new('http://localhosta:9292/faye')
    end
end
