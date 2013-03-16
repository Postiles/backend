class CreateBoardAdministratorships < ActiveRecord::Migration
  def up
    create_table :board_administratorships do |t|
      t.integer :board_id, :null => false
      t.integer :administrator_id, :null => false

      t.timestamps
    end
  end

  def down
    drop_table :board_administratorships
  end
end
