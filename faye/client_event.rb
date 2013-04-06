class ClientEvent
    def incoming(message, callback)
        puts message.inspect

        callback.call(message)
    end
end
