class AddAnonymousAndDefaultViewToBoard < ActiveRecord::Migration
  def up
    add_column :boards, :anonymous, :boolean
    add_column :boards, :default_view, :string
  end

  def down
    remove_column :boards, :anonymous
    remove_column :boards, :default_view
  end
end
