require 'faye'
load 'faye/client_event.rb'
Faye::WebSocket.load_adapter('thin')
bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
bayeux.add_extension(ClientEvent.new)
run bayeux
