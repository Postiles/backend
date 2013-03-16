class AddImageUrlAndVideoLinkAndTypeToPost < ActiveRecord::Migration
  def up
    add_column :posts, :type, :string
    add_column :posts, :image_url, :string
    add_column :posts, :video_link, :string
  end

  def down
    remove_column :posts, :type
    remove_column :posts, :image_url
    remove_column :posts, :video_link
  end
end
