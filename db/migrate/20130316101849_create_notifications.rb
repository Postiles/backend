class CreateNotifications < ActiveRecord::Migration
  def up
    create_table :notifications do |t|
      t.string :notification_type
      t.integer :target_id
      t.boolean :read
      t.integer :from_user_id
      t.references :user

      t.timestamps
    end
  end

  def down
    drop_table :notifications
  end
end
