class CreateUserData < ActiveRecord::Migration
  def up
    create_table :user_data do |t|
      t.string :email_confirmation_token
      t.string :password_forgot_confirmation_token
      t.string :current_ip
      t.string :last_sign_in_ip
      t.integer :sign_in_count
      t.boolean :email_confirmed
      t.boolean :got_started
      t.boolean :deleted
      t.references :user

      t.timestamps
    end
    add_index :user_data, :user_id
  end

  def down
    drop_table :user_data
  end
end
