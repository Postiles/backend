class BoardRegion < ActiveRecord::Base
  belongs_to :board
  attr_accessible :convolution, :points, :pos_x, :pos_y, :span_x, :span_y
end
