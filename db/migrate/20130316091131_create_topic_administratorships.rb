class CreateTopicAdministratorships < ActiveRecord::Migration
  def up
    create_table :topic_administratorships do |t|
      t.integer :topic_id, :null => false
      t.integer :administrator_id, :null => false

      t.timestamps
    end
  end
  
  def down
    drop_table :topic_administratorships
  end
end
