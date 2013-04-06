require 'faye'
load 'faye/client_event.rb'
bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
bayeux.listen(9292)
bayeux.add_extension(ClientEvent.new)
run bayeux
