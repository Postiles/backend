class CreateBoardRegions < ActiveRecord::Migration
  def up
    create_table :board_regions do |t|
      t.integer :pos_x
      t.integer :pos_y
      t.integer :span_x
      t.integer :span_y
      t.integer :points
      t.integer :convolution
      t.references :board

      t.timestamps
    end
    add_index :board_regions, :board_id
  end

  def down
    drop_table :board_regions
  end
end
