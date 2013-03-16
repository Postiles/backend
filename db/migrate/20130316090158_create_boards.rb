class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :name
      t.string :description
      t.string :image_url
      t.string :image_small_url
      t.boolean :deleted
      t.references :topic
      t.integer :creator_id, :null => false

      t.timestamps
    end
    add_index :boards, :topic_id
  end
end
