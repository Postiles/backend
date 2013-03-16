class Channel < ActiveRecord::Base
  attr_accessible :bottom_bound, :channel_str, :left_bound, :right_bound, :top_bound, :user_id, :board_id
end
