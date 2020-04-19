class CreateAdminUser < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_users do |t|
      t.string :uuid, :null => false
      t.string :name, :null => false
      t.string :email, :null => false

      t.string :crypted_password
      t.string :password_salt
      t.string :perishable_token, index: { unique: true }
      t.string :persistence_token, index: { unique: true }

      t.timestamps
    end
  end
end
