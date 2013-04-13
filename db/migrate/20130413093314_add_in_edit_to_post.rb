class AddInEditToPost < ActiveRecord::Migration
  def up
    add_column :posts, :in_edit, :boolean
  end

  def down
    remove_column :posts, :in_edit
  end
end
