class FixDbColumns < ActiveRecord::Migration
  def change
    rename_column :users, :salt, :password_salt
	rename_column :users, :encrypted_password, :password_hash
  end
end
