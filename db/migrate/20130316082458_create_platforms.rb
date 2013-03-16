class CreatePlatforms < ActiveRecord::Migration
  def up
    create_table :platforms do |t|
      t.string :name
      t.string :description
      t.string :announcement
      t.string :permission_type
      t.string :image_url
      t.string :image_small_url
      t.boolean :verified
      t.boolean :closed
      t.integer :creator_id

      t.timestamps
    end
  end

  def down
    drop_table :platforms
  end
end
