class CreatePlatformMemberships < ActiveRecord::Migration
  def up
    create_table :platform_memberships do |t|
      t.integer :platform_id, :null => false
      t.integer :member_id, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :platform_memberships
  end
end
