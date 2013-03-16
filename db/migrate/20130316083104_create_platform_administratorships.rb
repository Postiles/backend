class CreatePlatformAdministratorships < ActiveRecord::Migration
  def up
    create_table :platform_administratorships do |t|
      t.integer :platform_id, :null => false
      t.integer :administrator_id, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :platform_administratorships
  end
end
