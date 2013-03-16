class CreateProfiles < ActiveRecord::Migration
  def up
    create_table :profiles do |t|
      t.string :image_url
      t.string :image_small_url
      t.string :first_name
      t.string :last_name
      t.string :education
      t.string :work
      t.string :location
      t.string :hometown
      t.string :signiture
      t.string :personal_description
      t.string :website
      t.string :language
      t.references :user

      t.timestamps
    end
    add_index :profiles, :user_id
  end

  def down
    drop_table :profiles
  end
end
