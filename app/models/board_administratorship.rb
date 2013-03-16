class BoardAdministratorship < ActiveRecord::Base
  belongs_to :board, :class_name => :Board
  belongs_to :administrator, :class_name => :User

  attr_accessible :board_id, :administrator_id
end
