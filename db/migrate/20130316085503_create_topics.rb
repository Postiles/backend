class CreateTopics < ActiveRecord::Migration
  def up
    create_table :topics do |t|
      t.string :name
      t.string :description
      t.string :announcement
      t.string :image_url
      t.string :image_small_url
      t.string :permission_type
      t.boolean :deleted
      t.references :platform
      t.integer :creator_id, :null => false

      t.timestamps
    end
    add_index :topics, :platform_id
  end

  def down
    drop_table :topics
  end
end
