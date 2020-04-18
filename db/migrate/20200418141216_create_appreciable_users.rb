class CreateAppreciableUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :appreciable_users, id: false do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :slug, null: false, index: { unique: true }, primary_key: true

      t.timestamps
    end
  end
end
