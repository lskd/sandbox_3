class AddUidAndProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string

    add_index "users", ["provider"], name: "index_users_on_provider"
    add_index "users", ["uid"], name: "index_users_on_uid"
    add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
        
  end
end
