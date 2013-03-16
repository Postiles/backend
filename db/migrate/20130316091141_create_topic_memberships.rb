class CreateTopicMemberships < ActiveRecord::Migration
  def up
    create_table :topic_memberships do |t|
      t.integer :topic_id, :null => false
      t.integer :member_id, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :topic_memberships
  end
end
