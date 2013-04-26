class AddPasswordToGradDinUser < ActiveRecord::Migration
  def up
    add_column :grad_din_users, :password, :string
  end

  def down
    remove_column :grad_din_users, :password
  end
end
