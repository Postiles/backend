class CreateInlineComments < ActiveRecord::Migration
  def up
    create_table :inline_comments do |t|
      t.string :content
      t.references :post
      t.integer :creator_id

      t.timestamps
    end
    add_index :inline_comments, :post_id
  end

  def down
    drop_table :inline_comments
  end
end
