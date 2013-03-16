class CreatePosts < ActiveRecord::Migration
  def up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :span_x
      t.integer :span_y
      t.integer :pos_x
      t.integer :pos_y
      t.references :board
      t.integer :creator_id

      t.timestamps
    end
    add_index :posts, :board_id
  end

  def down
    drop_table :posts
  end
end
