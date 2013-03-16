class CreateFriendships < ActiveRecord::Migration
  def up
    create_table :friendships do |t|
      t.integer :pos_user_id, :null => false
      t.integer :neg_user_id, :null => false
      t.string :friendship_type

      t.timestamps
    end
  end

  def down
    drop_table :friendships
  end
end
