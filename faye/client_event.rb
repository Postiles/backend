class ClientEvent
    MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect']
    CHANNEL_BOARD_REGEX = /(?<=\/faye\/)\d+/ # match pattern of /faye/num, negative lookbehind
    def initialize
      @users = Hash.new()
    end
    def incoming(message, callback)
        return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']

        if MONITORED_CHANNELS[0].eql? message['channel']
          if CHANNEL_BOARD_REGEX.match(message['subscription'])
            board_id = CHANNEL_BOARD_REGEX.match(message['subscription'])[0]
            @users[message['clientId']]=board_id
            faye_client.publish('/faye/status/'+board_id, 
            {'status'=>'online','msg'=>{'count'=>@users.size,'board_id'=>board_id}})
          end
        else
          board_id = @users[message['clientId'] ]
          @users.delete(message['clientId'])
#            puts "board id: " + board_id
          if board_id             
            faye_client.publish('/faye/status/'+board_id,
            {'status'=>'offline','msg'=>{'count'=>@users.size,'board_id'=>board_id}})
          end
        end
        callback.call(message)

    end
    def outgoing(message, callback)
        callback.call(message)
    end
    def faye_client
        @faye_client ||= Faye::Client.new('http://localhost:9292/faye')
    end
end
