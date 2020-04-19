class CreateAdminAuthorization < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :admin_user, index: true
    end
  end
end
