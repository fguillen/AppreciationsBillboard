class CreateAppreciations < ActiveRecord::Migration[5.2]
  def change
    create_table :appreciations, id: false do |t|
      t.string :uuid, null: false, limit: 36, index: { unique: true }, primary_key: true
      t.string :by_slug, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_foreign_key :appreciations, :appreciable_users, column: :by_slug, primary_key: "slug"
  end
end
