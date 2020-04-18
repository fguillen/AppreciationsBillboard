class CreateJoinTableAppreciationsAppreciableUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :appreciable_users_appreciations, id: false, force: :cascade do |t|
      t.string :appreciation_uuid, null: false
      t.string :appreciable_user_slug, null: false
      t.index [:appreciable_user_slug, :appreciation_uuid], name: "appreciable_user_slug_appreciation_uuid"
      t.index [:appreciation_uuid, :appreciable_user_slug], name: "appreciation_uuid_appreciable_user_slug"
    end

    add_foreign_key :appreciable_users_appreciations, :appreciations, column: :appreciation_uuid, primary_key: "uuid"
    add_foreign_key :appreciable_users_appreciations, :appreciable_users, column: :appreciable_user_slug, primary_key: "slug"
  end
end
