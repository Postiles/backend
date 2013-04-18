class CreateInvitationRequests < ActiveRecord::Migration
  def change
    create_table :invitation_requests do |t|
      t.string :username
      t.string :email
      t.string :reason

      t.timestamps
    end
  end
end
