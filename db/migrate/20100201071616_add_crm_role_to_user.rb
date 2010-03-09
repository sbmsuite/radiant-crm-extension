class AddCrmRoleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :crm, :boolean, :default => 1
  end

  def self.down
    remove_column :users, :crm
  end
end
