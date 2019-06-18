class AdminUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :username

    add_column :users, :region, :string
    add_column :users, :admin, :boolean, default: false
  end
end
