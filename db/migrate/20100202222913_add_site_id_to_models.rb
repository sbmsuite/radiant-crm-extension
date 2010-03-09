class AddSiteIdToModels < ActiveRecord::Migration
  def self.up
    add_column :accounts, :site_id, :integer
    add_column :activities, :site_id, :integer
    add_column :campaigns, :site_id, :integer
    add_column :contacts, :site_id, :integer
    add_column :leads, :site_id, :integer
    add_column :opportunities, :site_id, :integer
    add_column :tasks, :site_id, :integer
  end

  def self.down
    remove_column :accounts, :site_id
    remove_column :activities, :site_id
    remove_column :campaigns, :site_id
    remove_column :contacts, :site_id
    remove_column :leads, :site_id
    remove_column :opportunities, :site_id
    remove_column :tasks, :site_id
  end
end
