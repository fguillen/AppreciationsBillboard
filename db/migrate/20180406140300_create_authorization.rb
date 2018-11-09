class CreateAuthorization < ActiveRecord::Migration[5.1]
  def change
    create_table :authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :admin_user, index: true
    end
  end
end
