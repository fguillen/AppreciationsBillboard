class CreateAppreciableAuthorizations < ActiveRecord::Migration[5.1]
  def change
    create_table :appreciable_authorizations do |t|
      t.string :provider
      t.string :uid
      t.references :appreciable_user, index: true
    end
  end
end
