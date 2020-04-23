class AddAuthlogicFieldsToAppreciableUsersTable < ActiveRecord::Migration[6.0]
  def change
    add_column :appreciable_users, :perishable_token, :string
    add_column :appreciable_users, :persistence_token, :string

    add_index :appreciable_users, :perishable_token, unique: true
    add_index :appreciable_users, :persistence_token, unique: true
  end
end
