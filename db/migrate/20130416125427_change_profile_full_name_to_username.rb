class ChangeProfileFullNameToUsername < ActiveRecord::Migration
  def up
    rename_column :profiles, :full_name, :username
  end

  def down
    rename_column :profiles, :username, :full_name
  end
end
