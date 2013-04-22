class CreateGradDinUsers < ActiveRecord::Migration
  def change
    create_table :grad_din_users do |t|
      t.string :chinese_name
      t.string :english_name
      t.string :email

      t.timestamps
    end
  end
end
