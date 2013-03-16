class CreateInterests < ActiveRecord::Migration
  def up
    create_table :interests do |t|
      t.boolean :liked
      t.boolean :followed
      t.references :user
      t.references :interestable, :polymorphic => true

      t.timestamps
    end
    add_index :interests, :user_id
  end

  def down
    drop_table :interests
  end
end
