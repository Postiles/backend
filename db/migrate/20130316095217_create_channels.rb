class CreateChannels < ActiveRecord::Migration
  def up
    create_table :channels do |t|
      t.string :channel_str
      t.integer :top_bound
      t.integer :bottom_bound
      t.integer :left_bound
      t.integer :right_bound
      t.references :user
      t.references :board

      t.timestamps
    end
  end

  def down
    drop_table :channels
  end
end
