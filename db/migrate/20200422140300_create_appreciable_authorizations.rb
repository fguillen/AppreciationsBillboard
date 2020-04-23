class CreateAppreciableAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :appreciable_authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :appreciable_user_id, index: true
    end
  end
end
