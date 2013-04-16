class ChangeProfileFirstAndLastNameToName < ActiveRecord::Migration
  def up
    rename_column :profiles, :first_name, :full_name
    remove_column :profiles, :last_name
  end

  def down
    rename_column :profiles, :full_name, :first_line
    add_column :profiles, :last_name
  end
end
