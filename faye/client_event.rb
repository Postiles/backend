class ClientEvent
    MONITORED_CHANNELS = [ '/meta/subscribe', '/meta/disconnect']
    CHANNEL_BOARD_REGEX = /(?<=\/faye\/)\d+/ # match pattern of /faye/num, negative lookbehind
    CHANNEL_STATUS_REGEX_BOARD = /(?<=\/faye\/status\/board\/)\d+/
    CHANNEL_STATUS_REGEX_USER = /(?<=\/user\/)\d+/
    def initialize
      @users = Hash.new()
    end
    def incoming(message, callback)
        return callback.call(message) unless MONITORED_CHANNELS.include? message['channel']
        callback.call(message)

        if MONITORED_CHANNELS[0].eql? message['channel']
            if CHANNEL_STATUS_REGEX_BOARD.match(message['subscription'])
                board_id = CHANNEL_STATUS_REGEX_BOARD.match(message['subscription'])[0]
                user_id = CHANNEL_STATUS_REGEX_USER.match(message['subscription'])[0]
                user = OnlineUser.new(board_id, user_id)
                #delete duplication
                @users.delete_if{|key,value| value.user_id == user_id}
                @users[message['clientId']] = user
                arr = Array.new
                @users.each_value{|value| arr.push(value.user_id)}
                msg = {'count'=>@users.size,'users'=>arr}
                faye_client.publish('/faye/status/'+board_id, 
                {'status'=>'online','msg'=>{'count'=>@users.size,'users'=>msg}})
            end
        else
            board_id = nil
            if @users[message['clientId'] ]
                board_id = @users[message['clientId']].board_id
            end
            @users.delete(message['clientId'])
            if board_id             
                arr = Array.new
                @users.each_value{|value| arr.push(value.user_id)}
                msg = {'count'=>@users.size,'users'=>arr}
                faye_client.publish('/faye/status/'+board_id, 
                {'status'=>'offline','msg'=>{'count'=>@users.size,'users'=>msg}})
          end
        end

    end
    def outgoing(message, callback)
        #puts message.inspect
        callback.call(message)
    end
    def faye_client
        @faye_client ||= Faye::Client.new('http://localhost:9292/faye')
    end
end

class OnlineUser
    def initialize(board_id, user_id)
        @board_id = board_id
        @user_id = user_id
    end
    def board_id
        @board_id
    end
    def user_id
        @user_id
    end
end

